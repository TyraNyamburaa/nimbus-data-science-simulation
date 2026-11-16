# Nimbus — Week 1 Exploratory Data Analysis & Conversion Report

**Author:** Tyra  
**Date:** 16 November 2026 *(Completed via Week 1 Catch-Up Plan covering deferred Days 3-7 deliverables)*  
**Status:** Interim Baseline Analysis

---

## Executive Summary
After excluding `28` internal/QA seed accounts and accounting for broken backend trial-expiration statuses, Nimbus’s true **30-day trial-to-paid conversion rate is `55.1%` (`216` conversions out of `392` eligible external trials)**. Conversion is not uniformly flat across the user base; rather, three major structural drivers explain current performance:
1. **Unenforced Trial Expiration:** `174` of `176` unconverted trial users (`98.9%`) remain in `status == 'trial'` and continue logging product events more than 14 days after starting their trial.
2. **Onboarding Completion Gap:** Users who complete onboarding convert at **`69.3%`** versus **`33.1%`** for those who do not (`+36.2 pp` gap), yet `39.3%` of trialists fail to finish onboarding.
3. **Segment & Cohort Divergence:** Micro-businesses (`1-5` employees, `48.2%` of trials) convert at **`49.2%`** compared to **`62.3%`** for `6-20` employee teams, and monthly conversion dipped from Q1 highs (`59.5%-72.2%`) to July-August lows (`41.7%-49.1%`).

---

## Business Question
What is Nimbus’s accurate baseline trial-to-paid conversion rate after resolving data-quality anomalies, and which customer behaviors, segments, and product friction points explain flat conversion performance?

---

## Data Sources
All five core relational tables were audited and joined (`100%` foreign-key referential integrity verified):
* `users.csv`: `420` rows × `7` columns (user profile, `is_internal`, `signup_at`, `onboarding_completed`).
* `organizations.csv`: `180` rows × `5` columns (`165` active in users/subscriptions; `company_size`, `acquisition_channel`).
* `subscriptions.csv`: `420` rows × `8` columns (`plan`, `status`, `trial_started_at`, `converted_at`, `cancelled_at`).
* `user_events.csv`: `6,942` rows × `5` columns (`6,862` unique `event_id`s across 6 event types).
* `support_tickets.csv`: `120` rows × `7` columns (`103` unique users; `status`, `category`, `resolution_type`).

---

## Metric Definitions
* **30-Day Trial-to-Paid Conversion Rate (Interim):** Percentage of eligible external trial users (`is_internal == False`, `trial_started_at` present, ≥30 days elapsed by `2026-11-16`) who record a `converted_at` timestamp within `30 days` of `trial_started_at`.
* **Interim Trial Expiration Rule:** Unconverted trials older than 14 days with no `user_events` logged after Day 14 are classified as **expired**; those with events after Day 14 are classified as **post-trial active non-converters**.

---

## Data-Quality Findings
1. **Un-expired Trial Status Bug:** `176` unconverted external trials past Day 14 still carry `status == 'trial'` in `subscriptions.csv`, and `174` of them continue generating `user_events` past Day 14.
2. **100% Null Cancellation Field:** `cancelled_at` is empty across all `420` rows, making paid churn and subscription lifespan unmeasurable from this table.
3. **Internal QA Seed Accounts:** `28` users (`6.7%`) are internal Nimbus test accounts (`is_internal == True`, `created_by == 'qa_seed'`, `plan == 'internal'`).
4. **Duplicate Event Records & Ingestion Lag:** `user_events.csv` contains `80` duplicate `event_id` rows (`6,942` total vs. `6,862` unique) and a consistent ~11-minute ingestion delay (`ingested_at - occurred_at`).

---

## Conversion Baseline
* **Total External Trials Started:** `392`
* **Eligible Trials (Completed 30-Day Observation Window):** `392`
* **Converted Within 30 Days:** `216`
* **30-Day Baseline Conversion Rate:** **`55.1%`**
* **Unconverted Trials (>14 Days):** `176` (`2` expired with no post-Day-14 activity; `174` still logging events after Day 14).

---

## Cohort Findings
* **Monthly Cohorts:** Conversion peaked in **February (`72.2%`, `n=36`)** and **April (`61.8%`, `n=34`)**, held steady in May-June (`53.1%-54.0%`), and dropped to **`41.7%` in July (`n=36`)** and **`49.1%` in August (`n=57`)** before recovering slightly in September (`53.8%`, `n=39`).
* **Acquisition Channel:** `paid_search` (`58.5%`, `n=94`), `referral` (`58.2%`, `n=79`), and `sales` (`57.1%`, `n=49`) outperform `partner` (`51.3%`, `n=39`) and `organic` (`51.1%`, `n=131`).
* **Company Size:** `6-20` employees (`62.3%`, `n=106`) and `51+` employees (`61.3%`, `n=31`) convert significantly higher than `21-50` (`57.6%`, `n=66`) and `1-5` micro-teams (`49.2%`, `n=189`).

---

## Onboarding Findings
* **Completed Onboarding (`True`):** **`69.3%`** conversion (`165 / 238` trials).
* **Incomplete Onboarding (`False`):** **`33.1%`** conversion (`51 / 154` trials).
* **Gap:** **`+36.2 percentage points`** (`2.09x` relative conversion rate). Note: Correlational only; confounded by user intent and acquisition channel (`paid_search` converts at `58.5%` despite only `54.3%` onboarding completion).

---

## Support-Ticket Findings
* **By Category:** `onboarding` tickets (`63.6%`, `n=44`) and `feature_request` tickets (`58.8%`, `n=17`) convert above the `no_ticket` baseline (`54.7%`, `n=289`), while `technical` (`53.7%`, `n=41`) and `billing` (`50.0%`, `n=18`) convert slightly below.
* **Open vs. Resolved:** Resolved tickets (`57.8%`, `n=64`) and open/pending tickets (`57.1%`, `n=56`) convert at nearly identical rates. Ticket submission reflects both product engagement and friction, while lack of a ticket does not guarantee a frictionless experience.

---

## Limitations
* **Observational / Correlational Data:** Segment and onboarding differences cannot establish causality without controlled A/B tests.
* **Broken Lifecycle Timestamps:** Missing `cancelled_at` values and un-enforced trial expiration dates distort lifecycle states.
* **Small Sub-Segment Sample Sizes:** Weekly cohorts (`1-27` trials) and specific ticket categories (`17-44` records) carry wide confidence intervals.
* **User-Level vs. Org-Level Granularity:** Multiple users belong to the same organization (`392` users across `165` orgs), which may cluster conversion behavior at the company level.

---

## Recommendations

### Recommendation 1: Enforce 14-Day Trial Expiration & Paywall Gating
* **Observation:** `174` of `176` unconverted trial users (`98.9%`) remain in `trial` status and continue logging `user_events` past Day 14 without paying.
* **Possible explanation:** A backend billing/entitlement bug fails to expire trials after 14 days, removing urgency for active evaluators to convert to a paid plan.
* **Confidence:** High
* **Recommended action:** Partner with Engineering to audit subscription entitlement enforcement, automatically transition unconverted trials to `expired` at Day 14 (with a grace/upgrade prompt), and log `expired_at` / `cancelled_at` timestamps.
* **Success metric:** Reduction in post-Day-14 unpaid active trial accounts from `98.9%` to `<5%`, and a `+5 to +10 pp` lift in 30-day conversion among newly expiring cohorts.

### Recommendation 2: Redesign & Instrument the Onboarding Flow
* **Observation:** `39.3%` of external users (`154/392`) do not complete onboarding, and non-completers convert at `33.1%` compared to `69.3%` for completers (`-36.2 pp`).
* **Possible explanation:** Users encounter setup friction early in the trial or fail to reach Nimbus’s core activation milestone before losing momentum.
* **Confidence:** Medium
* **Recommended action:** Map step-by-step drop-off using `user_events` (`create_project`, `invite_member`, etc.), add `onboarding_completed_at` tracking, and run an A/B test with guided in-app checklists and Day 3 reminder emails for incomplete users.
* **Success metric:** Increase onboarding completion rate from `60.7%` to `>75%` and measure incremental 30-day conversion lift in the treatment group.

### Recommendation 3: Improve Micro-Business (`1-5`) & Organic Packaging/Messaging
* **Observation:** `1-5` employee organizations make up `48.2%` of all external trials (`189/392`) but convert at the lowest rate (`49.2%`), while `organic` is the largest channel (`33.4%` of trials) with the lowest conversion (`51.1%`).
* **Possible explanation:** Solo founders and micro-teams may find current pricing tiers mismatched to smaller seat counts, or organic visitors arrive with lower buying readiness than `paid_search` (`58.5%`) and `referral` (`58.2%`) leads.
* **Confidence:** Medium
* **Recommended action:** Conduct 8-10 exit interviews with unconverted `1-5` employee users and test tailored starter-tier positioning or self-serve ROI templates for organic signups.
* **Success metric:** Lift `1-5` employee 30-day conversion rate from `49.2%` to `>55%` over the next two monthly cohorts.

### Recommendation 4: Fix Event Deduplication & Billing/Technical Ticket Triage
* **Observation:** `user_events.csv` contains `80` duplicate `event_id` records, and users with `billing` (`50.0%`) or `technical` (`53.7%`) tickets convert below users with `onboarding` tickets (`63.6%`).
* **Possible explanation:** Retry logic in the event ingestion pipeline creates duplicate logs, while unresolved billing/technical blockers during trials stall purchase decisions.
* **Confidence:** High
* **Recommended action:** Add an idempotency constraint on `event_id` in the data warehouse ETL and prioritize SLA fast-tracking for `billing` and `technical` tickets opened by active trial users.
* **Success metric:** `0` duplicate `event_id` records in production tables and `<24-hour` median resolution time for trial `billing`/`technical` tickets.

---

## Next Steps
1. Share this Week 1 report and interim baseline definition with Maya for sign-off.
2. Confirm with Data Engineering whether `cancelled_at` and `expired` status transitions exist in upstream billing logs (e.g., Stripe) so production metrics can be backfilled.
