# Nimbus Data Quality Audit - Trial Lifecycle and Event Coverage

**Author:** Tyra Nyambura  
**Date:** 11 November 2026  
**Status:** Draft for engineering and product review  
**Scope:** Trial lifecycle integrity, subscription-status reliability, and event coverage for conversion analysis  

## Executive summary

This audit examines whether Nimbus can currently calculate a reliable trial-to-paid conversion rate from the available subscription and event data.

The main finding is that `subscriptions.status = 'trial'` is not a reliable indicator of an active trial. A total of **176 non-internal trials** older than 14 days remain marked as `trial`, with no `cancelled_at` timestamp and no trial-expiration event. This suggests that expired trials may remain in the trial denominator indefinitely.

Until the trial-expiration rule is validated and implemented, a conversion rate calculated as conversions divided by all records with `status = 'trial'` would likely be understated.

## Business context

Nimbus offers a 14-day free trial. The company’s current growth concern is that trial signups are increasing while trial-to-paid conversion has remained flat for the last 90 days.

Before investigating why conversion is flat, this audit checks whether the trial population and event data are reliable enough to support a conversion analysis.

## Data sources

| Table | Purpose | Key fields used |
|---|---|---|
| `users` | Identify customers, internal users, and onboarding status | `user_id`, `is_internal`, `email`, `created_by`, `onboarding_completed` |
| `organizations` | Identify customer companies and acquisition channel | `organization_id`, `company_size`, `acquisition_channel` |
| `subscriptions` | Identify trial, paid, and cancelled subscription records | `subscription_id`, `plan`, `status`, `trial_started_at`, `converted_at`, `cancelled_at` |
| `user_events` | Measure product activity | `event_id`, `user_id`, `event_name`, `occurred_at`, `ingested_at` |
| `support_tickets` | Understand customer friction and support outcomes | `ticket_id`, `user_id`, `status`, `category`, `resolution_type`, `closed_reason` |

## Audit questions

1. Are there trials that remain in `trial` status beyond the 14-day trial period?
2. Is trial expiration recorded anywhere in the data?
3. Do active paid users have product activity after conversion?
4. Can billing-owner inactivity be explained by activity from other users in the same organization?
5. Can the current trial population support a reliable conversion-rate calculation?

## Findings

### Finding 1: 176 trials appear stale

**Finding:** 176 non-internal trials have `status = 'trial'` despite starting more than 14 days ago.

| Check | Result |
|---|---|
| Trials older than 14 days with `status = 'trial'` | 176 |
| Earliest stale trial start date | 2 January 2026 |
| Latest stale trial start date | 27 September 2026 |

**Interpretation:** These records may include expired trials, but they cannot currently be distinguished from active, paused, extended, or sales-managed trials.

**Business impact:** If these records remain in the conversion denominator, the reported trial-to-paid conversion rate will be understated.

### Finding 2: Trial expiration is not recorded

**Finding:** No trial-expiration event was identified, and stale trials do not have a `cancelled_at` value.

| Check | Result |
|---|---|
| `cancelled_at` recorded for stale trials | No |
| Trial-expiration event identified | No |
| Automated status transition identified | Not evident from available data |
| Ability to distinguish abandoned from active trials | No |

**Interpretation:** The available data does not show a durable record of when a non-converting trial ended. This is a lifecycle-data gap rather than proof that every stale trial was abandoned.

**Business impact:** Nimbus cannot currently measure trial expiry, abandonment, or time-to-expiration reliably from the subscription table alone.

### Finding 3: Active paid users have event coverage

**Finding:** All 128 active paid users have at least one recorded event.

| Check | Result |
|---|---|
| Active paid users | 128 |
| Active paid users with zero events | 0 |
| Interpretation | Event coverage appears broadly reliable for converted users |

**Interpretation:** The absence of events among converted users does not appear to be a widespread issue. This supports using event data for post-conversion engagement analysis, subject to further validation of event definitions and deduplication.

### Finding 4: Five billing owners have no post-conversion activity

**Finding:** Five billing owners have no recorded events after conversion, but each has other active users within the same organization.

| Check | Result |
|---|---|
| Billing owners with zero post-conversion events | 5 |
| Other active users in the same organizations | Yes |
| Event range among teammates | 21–58 events per user |
| Likely explanation | The billing owner may not be the primary product user |

**Interpretation:** This pattern does not necessarily indicate missing event data. A subscription may be owned by an administrator or purchaser while other members of the organization generate product activity.

**Business impact:** Product-usage and retention analysis should distinguish the billing owner from active product users. Organization-level activity may be more appropriate for some retention questions.

### Finding 5: Support tickets are not a complete measure of customer struggle

**Finding:** Some users who did not complete onboarding have no support ticket.

**Interpretation:** The absence of a support ticket does not prove that a customer could not reach support. Customers may choose not to contact support, may churn silently, or may experience friction without submitting a ticket.

**Business impact:** Support-ticket volume should be treated as one signal among several, not as a complete measure of onboarding difficulty.

## Anomaly classification

| Anomaly | Classification | Rationale | Recommended action |
|---|---|---|---|
| 176 trials remain `trial` after 14 days | Lifecycle gap | No expiration event or cancellation timestamp is available | Validate trial rules with engineering; define an interim analysis-time expiration rule |
| No trial-expiration tracking | Engineering review | No event or timestamp records when a non-converting trial ends | Implement a durable `expired` status or expiration timestamp |
| Five billing owners have no post-conversion events | Likely expected behavior | Teammates in the same organizations are active | Validate whether subscription ownership differs from product usage |
| Zero active paid users with zero events | Expected | All converted users have recorded activity | No immediate action required |
| Failed-onboarding users with no tickets | Not necessarily a data issue | Support contact is optional | Combine tickets with onboarding-completion and event data |

## Conversion-rate impact

The current trial population appears inflated by stale trial records.

A simple conversion calculation using:

```sql
conversions / all trials with status = 'trial'
```

would include expired trials in the denominator. This would understate conversion.

However, it would be premature to remove all 176 stale trials without confirming the business rules. Some may be legitimate extended or paused trials.

## Recommended conversion definition

Until engineering implements a durable expiration status, use an analysis-time definition.

### Proposed definition

A trial is considered **expired for analysis** if all of the following are true:

1. The user is not internal or a test account.
2. The subscription has `trial_started_at`.
3. The subscription has no `converted_at` value.
4. The trial started more than 14 days ago.
5. The user has no qualifying product activity after day 14.

A trial is considered **converted** if `converted_at` occurs within 30 days of `trial_started_at`.

Only trial cohorts whose full observation window has elapsed should be included in the conversion-rate calculation.

### Example

For a trial started on 1 October 2026:

- The 14-day trial period ends on 15 October 2026.
- The 30-day conversion-observation window ends on 31 October 2026.
- If the user converts by 31 October, count the trial as converted.
- If the user does not convert and has no qualifying activity after 15 October, classify the trial as expired for analysis.
- If the user remains active after day 14, do not automatically classify the trial as expired without further validation.

## Required validation

Before finalizing the conversion metric, confirm the following with engineering and product:

1. Is the official trial duration 14 days for all plans and acquisition channels?
2. Are there extended, paused, or sales-managed trials?
3. Does a scheduled job update subscription status after trial expiration?
4. Should `status` transition from `trial` to `expired`, `cancelled`, or another value?
5. Should historical stale trials be backfilled?
6. Should product usage be measured at the user level or organization level?
7. What event qualifies as meaningful product activity?
8. Which conversion window does leadership already use?

## Recommendations

### Immediate analysis recommendation

Do not report a conversion rate using `status = 'trial'` as the denominator.

Instead, calculate a preliminary conversion rate using:

- A defined cohort of trials with a completed observation window
- Internal and test accounts excluded
- Conversion defined as `converted_at` within the agreed window
- Expired trials excluded using the validated analysis-time rule

### Product and engineering recommendation

Implement a durable trial-lifecycle state.

Recommended options:

- Add a `trial_expired_at` timestamp.
- Add an `expired` subscription status.
- Emit a `trial_expired` event.
- Backfill historical records only after the expiration rule is validated.

### Data-quality recommendation

Add monitoring for:

- Trials older than the official trial period still marked as `trial`
- Paid users with no events after conversion
- Event-ingestion gaps or delayed events
- Duplicate `event_id` values
- Organizations with a paying billing owner but no product activity

## Limitations

- This audit relies on the available mock warehouse tables and may not include all source-system fields.
- The 14-day trial period is based on the product documentation and should be confirmed with engineering.
- The absence of an expiration event does not prove that expiration logic does not exist elsewhere in the system.
- Event absence does not prove that a user took no action; it may reflect incomplete instrumentation or delayed ingestion.
- Support-ticket absence does not prove that a customer did not experience friction.

## Next steps

1. Send the trial-lifecycle questions to Priya and Daniel.
2. Confirm the official trial duration and expiration process.
3. Validate whether product usage should be measured at the user or organization level.
4. Calculate a preliminary conversion rate using completed cohorts and the interim expiration rule.
5. Compare the result with the current flat conversion narrative.
6. Prepare a stakeholder-ready conversion readout for Maya.
