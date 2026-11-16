# Nimbus Cohort & Segment Conversion Analysis

> **Methodology Note:** Completed **16 November 2026** using the interim baseline definition (`392` eligible external trials, 30-day conversion window). All percentages reflect `conversions / eligible trials` within each segment.

---

## 1. Trial Start Cohort (Monthly)
*(Note: In this dataset, `signup_at` and `trial_started_at` occur on the same date for external users, making monthly trial start cohorts and monthly signup cohorts identical.)*

| Trial Start Cohort | Eligible Trials | Conversions (≤30d) | Conversion Rate | Sample Size Note |
| :--- | :---: | :---: | :---: | :--- |
| **2026-01** | 37 | 22 | **59.5%** | Moderate sample |
| **2026-02** | 36 | 26 | **72.2%** | Peak monthly cohort |
| **2026-03** | 26 | 15 | **57.7%** | Small sample (`n < 30`) |
| **2026-04** | 34 | 21 | **61.8%** | Moderate sample |
| **2026-05** | 64 | 34 | **53.1%** | High volume cohort |
| **2026-06** | 63 | 34 | **54.0%** | High volume cohort |
| **2026-07** | 36 | 15 | **41.7%** | Lowest monthly cohort |
| **2026-08** | 57 | 28 | **49.1%** | High volume cohort |
| **2026-09** | 39 | 21 | **53.8%** | Moderate sample |
| **Overall** | **392** | **216** | **55.1%** | Full completed window |

* **Key Pattern:** Conversion rates peaked in **Q1/early Q2 (`57.7%-72.2%`)** before slipping in **July (`41.7%`)** and **August (`49.1%`)**, even as monthly trial volume scaled up in May-August.
* **Potential Limitation:** Monthly cohorts range from `26` to `64` trials, meaning single-month swings (such as February's `72.2%` vs. July's `41.7%`) are sensitive to small-sample variance and channel mix shifts.

---

## 2. Signup Week Cohorts
Weekly cohorts span **39 weeks** from `2025-12-29/2026-01-04` through `2026-09-21/2026-09-27` (`n = 392` total).

| Signup Week | Trials | Conversions | Conv. Rate | Signup Week | Trials | Conversions | Conv. Rate |
| :--- | :---: | :---: | :---: | :--- | :---: | :---: | :---: |
| 2025-12-29/2026-01-04 | 1 | 0 | 0.0% | 2026-05-18/2026-05-24 | 16 | 11 | 68.8% |
| 2026-01-05/2026-01-11 | 15 | 10 | 66.7% | 2026-05-25/2026-05-31 | 27 | 14 | 51.9% |
| 2026-01-12/2026-01-18 | 9 | 7 | 77.8% | 2026-06-01/2026-06-07 | 7 | 4 | 57.1% |
| 2026-01-19/2026-01-25 | 5 | 3 | 60.0% | 2026-06-08/2026-06-14 | 11 | 6 | 54.5% |
| 2026-01-26/2026-02-01 | 7 | 2 | 28.6% | 2026-06-15/2026-06-21 | 17 | 8 | 47.1% |
| 2026-02-02/2026-02-08 | 14 | 11 | 78.6% | 2026-06-22/2026-06-28 | 25 | 16 | 64.0% |
| 2026-02-09/2026-02-15 | 10 | 7 | 70.0% | 2026-06-29/2026-07-05 | 8 | 4 | 50.0% |
| 2026-02-16/2026-02-22 | 3 | 1 | 33.3% | 2026-07-06/2026-07-12 | 19 | 7 | 36.8% |
| 2026-02-23/2026-03-01 | 10 | 7 | 70.0% | 2026-07-13/2026-07-19 | 4 | 1 | 25.0% |
| 2026-03-02/2026-03-08 | 8 | 4 | 50.0% | 2026-07-20/2026-07-26 | 6 | 2 | 33.3% |
| 2026-03-09/2026-03-15 | 4 | 3 | 75.0% | 2026-07-27/2026-08-02 | 2 | 1 | 50.0% |
| 2026-03-16/2026-03-22 | 8 | 6 | 75.0% | 2026-08-03/2026-08-09 | 23 | 11 | 47.8% |
| 2026-03-23/2026-03-29 | 3 | 2 | 66.7% | 2026-08-10/2026-08-16 | 11 | 5 | 45.5% |
| 2026-03-30/2026-04-05 | 12 | 7 | 58.3% | 2026-08-17/2026-08-23 | 12 | 7 | 58.3% |
| 2026-04-06/2026-04-12 | 17 | 11 | 64.7% | 2026-08-24/2026-08-30 | 10 | 5 | 50.0% |
| 2026-04-13/2026-04-19 | 1 | 1 | 100.0% | 2026-08-31/2026-09-06 | 3 | 0 | 0.0% |
| 2026-04-20/2026-04-26 | 4 | 1 | 25.0% | 2026-09-07/2026-09-13 | 20 | 13 | 65.0% |
| 2026-04-27/2026-05-03 | 7 | 4 | 57.1% | 2026-09-14/2026-09-20 | 2 | 0 | 0.0% |
| 2026-05-04/2026-05-10 | 7 | 4 | 57.1% | 2026-09-21/2026-09-27 | 15 | 8 | 53.3% |
| 2026-05-11/2026-05-17 | 9 | 2 | 22.2% | **Total** | **392** | **216** | **55.1%** |

* **Potential Limitation:** Weekly sample sizes are very small (`1` to `27` trials per week, averaging `10.1` trials/week), creating extreme noise (`0.0%` to `100.0%`). Monthly or bi-weekly aggregation should be used for decision-making.

---

## 3. Acquisition Channel Analysis

| Acquisition Channel | Eligible Trials | Conversions (≤30d) | Conversion Rate | Sample Size Share |
| :--- | :---: | :---: | :---: | :---: |
| **paid_search** | 94 | 55 | **58.5%** | 24.0% |
| **referral** | 79 | 46 | **58.2%** | 20.2% |
| **sales** | 49 | 28 | **57.1%** | 12.5% |
| **partner** | 39 | 20 | **51.3%** | 9.9% |
| **organic** | 131 | 67 | **51.1%** | 33.4% |
| **Overall** | **392** | **216** | **55.1%** | **100.0%** |

* **Key Pattern:** High-intent channels (`paid_search` at `58.5%`, `referral` at `58.2%`, and `sales` at `57.1%`) outperform `organic` (`51.1%`) and `partner` (`51.3%`) by roughly **6 to 7.4 percentage points**. Notably, `organic` brings in the largest share of trials (`33.4%`) but converts at the lowest rate.
* **Potential Limitation:** Attribution is stored at the `organization` level (`organizations.acquisition_channel`), meaning multi-user organizations share a single channel tag and self-reported/UTM attribution accuracy is unverified.

---

## 4. Company Size Analysis (`company_size_analysis.md`)

| Company Size | Eligible Trials | Conversions (≤30d) | Conversion Rate | Sample Size Share |
| :--- | :---: | :---: | :---: | :---: |
| **6-20** | 106 | 66 | **62.3%** | 27.0% |
| **51+** | 31 | 19 | **61.3%** | 7.9% |
| **21-50** | 66 | 38 | **57.6%** | 16.8% |
| **1-5** | 189 | 93 | **49.2%** | 48.2% |
| **Overall** | **392** | **216** | **55.1%** | **100.0%** |

* **Key Pattern:** Micro-businesses (`1-5` employees) represent nearly half of all trials (`48.2%`, `189/392`) but convert at just **`49.2%`**, trailing `6-20` employee teams (`62.3%`) by **13.1 percentage points**.
* **Potential Limitation:** `51+` organizations have a small sample (`31` trials), and multiple users from the same organization are counted individually in `subscriptions.csv` (`392` external users across `165` organizations).
