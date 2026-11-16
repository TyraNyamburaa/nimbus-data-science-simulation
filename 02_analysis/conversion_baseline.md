# Nimbus Conversion Baseline (Interim Analysis Definition)

> **Status & Label:** This document defines an **interim analysis definition**, not a final production metric. Completed on **16 November 2026** as part of the Week 1 catch-up plan following the Day 1-2 data audit.

---

## Business Question
What is Nimbus’s true baseline 30-day trial-to-paid conversion rate once internal/test accounts and broken backend trial-expiration statuses are accounted for, and why has conversion remained flat over time?

---

## Metric Definition
* **Metric Name:** 30-Day Trial-to-Paid Conversion Rate (Interim)
* **Formula:**
  $$\text{Conversion Rate} = \frac{\text{Eligible External Trials with } \texttt{converted\_at} \text{ within 30 days of } \texttt{trial\_started\_at}}{\text{Total Eligible External Trials with a Completed 30-Day Observation Window}}$$
* **Numerator (`216`):** External trial users whose `converted_at` timestamp falls between `0` and `30` days after `trial_started_at`.
* **Denominator (`392`):** All external users who started a trial at least 30 days prior to the reference date (`2026-11-16`), regardless of whether their current database `status` displays `trial` or `active`.

---

## Population and Exclusions
* **Starting Dataset:** `420` total rows in `subscriptions.csv` (1-to-1 with `users.csv`).
* **Exclusions Applied (`28` records removed):**
  1. **Internal & QA Accounts:** Excluded all `28` users where `is_internal == True` (`created_by == 'qa_seed'` / `plan == 'internal'`), all of whom also lacked a `trial_started_at` date.
  2. **Incomplete Observation Windows:** Checked for trials started fewer than 30 days prior to `2026-11-16` (`0` external trials fell under 30 days, as the latest trial started in September 2026).
* **Final Eligible Population:** **`392` external trials** with a completed 30-day observation window.

---

## Conversion Window
* **Window:** **30 days** from `trial_started_at` to `converted_at`.
* **Rationale:** Although Nimbus markets a 14-day trial period, backend records show users converting between days 15 and 30. Enforcing a uniform 30-day window captures delayed conversions consistently across all cohorts.

---

## Trial-Expiration Treatment
* **Audit Finding:** The backend does not transition unconverted trials to an `expired` status after Day 14—all **`176` unconverted external trials** still display `status == 'trial'` up to 170+ days after starting. Furthermore, `cancelled_at` is 100% null (`420/420` rows).
* **Interim Rule Applied:** Unconverted trials older than 14 days with no qualifying product activity (`user_events`) after Day 14 are treated as **expired** for analysis:
  * **Expired Trials (No activity after Day 14):** **`2` users** (true dormant drop-offs).
  * **Post-Trial Active Non-Converters (Activity logged after Day 14):** **`174` users** (`98.9%` of all unconverted trials continue using Nimbus past Day 14 without converting).

---

## Conversion Rate
* **Eligible External Trials (Denominator):** `392`
* **Conversions Within 30 Days (Numerator):** `216`
* **30-Day Baseline Conversion Rate:** **`55.1%`**
* **Unconverted Trials (>14 days):** `176` (`44.9%`), consisting of `2` expired trials and `174` post-trial active non-converters.

---

## Limitations
* **Unenforced Trial Expiration:** Because `174` of `176` unconverted users continue logging events past Day 14, users lack urgency to upgrade, blurring the line between active trial evaluation and free ongoing usage.
* **No Churn Visibility:** `cancelled_at` is completely null (`420/420`), so net retention and post-conversion cancellations cannot be measured.
* **Duplicate Telemetry & Ingestion Lag:** `user_events.csv` contains `80` duplicate `event_id` records (`6,942` raw vs. `6,862` unique) and an ~11-minute lag between `occurred_at` and `ingested_at`.
* **Observational Data Only:** Database logs cannot explain external buying friction (e.g., pricing objections or competitor switches) without customer interviews.

---

## Recommended Next Analysis
1. **Cohort & Segment Breakdown (`cohort_analysis.md`):** Disaggregate the `55.1%` baseline by signup week, trial start cohort, acquisition channel, and company size.
2. **Onboarding Funnel Analysis (`onboarding_conversion_analysis.md`):** Measure the conversion gap between users who complete onboarding versus those who do not.
3. **Support Ticket Impact (`support_ticket_analysis.md`):** Evaluate how support interactions across categories and resolution states correlate with conversion.
4. **Post-Day-14 Usage Audit:** Inspect which specific features the `174` unconverted post-trial users access after Day 14 to identify paywall gaps.
