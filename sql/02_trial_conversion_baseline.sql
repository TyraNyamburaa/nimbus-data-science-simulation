-- Baseline trial-to-paid conversion, excluding internal/test users
WITH trials AS (
  SELECT s.*, u.is_internal, u.onboarding_completed
  FROM subscriptions s
  JOIN users u USING(user_id)
  WHERE s.trial_started_at IS NOT NULL
    AND u.is_internal = false
)
SELECT
  COUNT(*) AS trials,
  SUM(CASE WHEN converted_at IS NOT NULL THEN 1 ELSE 0 END) AS conversions,
  ROUND(100.0 * SUM(CASE WHEN converted_at IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS conversion_rate_pct
FROM trials;