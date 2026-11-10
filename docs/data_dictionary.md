# Nimbus Data Dictionary

## users
| Column | Description |
|---|---|
| user_id | Unique user identifier |
| organization_id | Customer company |
| email | User email |
| is_internal | True for employee/QA accounts |
| created_by | How the account was created |
| signup_at | Account creation date |
| onboarding_completed | Whether the user completed onboarding |

## organizations
| Column | Description |
|---|---|
| organization_id | Unique company identifier |
| organization_name | Company name |
| company_size | Employee band |
| acquisition_channel | How the company was acquired |
| created_at | Company creation date |

## subscriptions
| Column | Description |
|---|---|
| subscription_id | Unique subscription |
| user_id | Billing owner |
| organization_id | Customer company |
| plan | trial, starter, pro, business, internal |
| status | trial, active, cancelled |
| trial_started_at | Trial start |
| converted_at | Date the trial converted to paid |
| cancelled_at | Cancellation date |

## user_events
| Column | Description |
|---|---|
| event_id | Unique event ID; use for deduplication |
| user_id | User who performed event |
| event_name | Event type |
| occurred_at | When the action happened |
| ingested_at | When the event reached the warehouse |

## support_tickets
| Column | Description |
|---|---|
| ticket_id | Unique ticket |
| user_id | Customer who opened ticket |
| status | resolved, open, awaiting_customer, escalated |
| category | onboarding, billing, technical, feature_request |
| resolution_type | How it was resolved |
| closed_reason | Why unresolved tickets remain open |
