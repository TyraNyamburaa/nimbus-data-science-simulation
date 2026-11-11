-- Count rows per table
SELECT 'users' AS table_name, COUNT(*) AS rows FROM users
UNION ALL SELECT 'organizations', COUNT(*) FROM organizations
UNION ALL SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL SELECT 'user_events', COUNT(*) FROM user_events
UNION ALL SELECT 'support_tickets', COUNT(*) FROM support_tickets;

-- Duplicate event IDs
SELECT event_id, COUNT(*) AS n
FROM user_events
GROUP BY event_id
HAVING COUNT(*) > 1;

-- Subscription status distribution
SELECT status, COUNT(*) AS count
FROM subscriptions
GROUP BY status;

-- Plan distribution
SELECT plan, COUNT(*) AS count
FROM subscriptions
GROUP BY plan;

-- Event name distribution
SELECT event_name, COUNT(*) AS count
FROM user_events
GROUP BY event_name
ORDER BY count DESC;

-- Trial audit: trials older than 14 days still in 'trial' status
SELECT
  COUNT(*) AS stale_trials,
  MIN(s.trial_started_at) AS earliest_trial,
  MAX(s.trial_started_at) AS latest_trial
FROM subscriptions s
JOIN users u ON u.user_id = s.user_id
WHERE s.status = 'trial'
  AND u.is_internal = 'False'
  AND s.trial_started_at < date('now', '-14 days');

-- Trial expiration check: any trial with cancelled_at or converted_at
SELECT COUNT(*) AS trials_with_cancelled_at
FROM subscriptions
WHERE status = 'trial'
  AND cancelled_at IS NOT NULL AND cancelled_at != '';

SELECT COUNT(*) AS trials_with_converted_at
FROM subscriptions
WHERE status = 'trial'
  AND converted_at IS NOT NULL AND converted_at != '';

-- All trial records for manual inspection
SELECT subscription_id, user_id, trial_started_at, converted_at, cancelled_at
FROM subscriptions
WHERE status = 'trial'
ORDER BY trial_started_at;

-- Active paid users with zero events (billing owner level)
SELECT
  s.user_id,
  s.plan,
  s.status,
  s.converted_at,
  COUNT(e.event_id) AS event_count,
  MAX(e.occurred_at) AS last_event
FROM subscriptions s
JOIN users u ON u.user_id = s.user_id
LEFT JOIN user_events e ON e.user_id = s.user_id
WHERE s.status = 'active'
  AND s.plan != 'internal'
  AND u.is_internal = 'False'
GROUP BY s.user_id, s.plan, s.status, s.converted_at
HAVING COUNT(e.event_id) = 0
ORDER BY s.converted_at;

-- Billing owners with zero events post-conversion, plus org activity
WITH billing_owners AS (
  SELECT s.user_id AS billing_owner, u.organization_id, s.converted_at
  FROM subscriptions s
  JOIN users u ON u.user_id = s.user_id
  LEFT JOIN user_events e
    ON e.user_id = s.user_id
    AND e.occurred_at >= s.converted_at
  WHERE s.status = 'active'
    AND s.plan != 'internal'
  GROUP BY s.user_id, u.organization_id, s.converted_at
  HAVING COUNT(e.event_id) = 0
)
SELECT
  bo.billing_owner,
  bo.organization_id,
  bo.converted_at,
  COUNT(DISTINCT u2.user_id) - 1 AS other_users_in_org,
  COUNT(e2.event_id) AS events_from_other_users,
  MAX(e2.occurred_at) AS last_event_from_others
FROM billing_owners bo
JOIN users u2 ON u2.organization_id = bo.organization_id AND u2.user_id != bo.billing_owner
LEFT JOIN user_events e2 ON e2.user_id = u2.user_id
GROUP BY bo.billing_owner, bo.organization_id, bo.converted_at;

-- Stale trial details with last activity
SELECT
  s.user_id,
  s.trial_started_at,
  s.status,
  COUNT(e.event_id) AS event_count,
  MAX(e.occurred_at) AS last_event
FROM subscriptions s
JOIN users u ON u.user_id = s.user_id
LEFT JOIN user_events e ON e.user_id = s.user_id
WHERE s.status = 'trial'
  AND u.is_internal = 'False'
  AND s.trial_started_at < date('now', '-14 days')
GROUP BY s.user_id, s.trial_started_at, s.status
ORDER BY last_event DESC
LIMIT 50;