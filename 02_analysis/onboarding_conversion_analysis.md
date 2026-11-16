# Onboarding Completion & Trial Conversion Analysis

> **Methodology Note:** Completed **16 November 2026** across `392` eligible external trials with a completed 30-day observation window.

---

## Conversion Comparison by Onboarding Status

| Onboarding Status | Eligible Trials (Sample Size) | Conversions (≤30d) | Non-Conversions | 30-Day Conversion Rate |
| :--- | :---: | :---: | :---: | :---: |
| **Completed (`True`)** | 238 (`60.7%`) | 165 | 73 | **69.3%** |
| **Not Completed (`False`)** | 154 (`39.3%`) | 51 | 103 | **33.1%** |
| **Overall / Difference** | **392 (`100.0%`)** | **216** | **176** | **+36.2 percentage points** (`2.09x` lift) |

* **Headline Finding:** Users who complete onboarding convert at **`69.3%`** (`165/238`), compared to **`33.1%`** (`51/154`) for users who do not complete onboarding—a **+36.2 percentage point difference** (more than double the conversion rate).
* **Opportunity Sizing:** `39.3%` of external trial users (`154/392`) fail to finish onboarding, accounting for `58.5%` (`103/176`) of all non-converting trials.

---

## Important Analytical Caveat: Correlation vs. Causation
* **This relationship is strictly correlational, not causal.** Completing onboarding does not automatically prove that the onboarding flow itself *caused* users to buy. Users who already have high purchase intent, budget approval, or an urgent workflow need are naturally more motivated to complete setup steps and subsequently subscribe.

---

## Potential Confounders
Before attributing the `+36.2 pp` lift solely to onboarding design, the following confounding variables must be accounted for:

1. **Acquisition Channel Mix:**
   * Onboarding completion varies noticeably by channel: `sales` (`67.3%`) and `organic` (`64.1%`) have higher completion rates than `paid_search` (`54.3%`), `partner` (`59.0%`), and `referral` (`59.5%`).
   * Interestingly, `paid_search` has the *lowest* onboarding completion (`54.3%`) yet the *highest* conversion rate (`58.5%`), proving that channel intent independently drives conversion alongside onboarding.
2. **Company Size & Buying Complexity:**
   * Onboarding completion is relatively consistent across company sizes (`58.1%` for `51+`, `59.8%` for `1-5`, `61.3%` for `6-20`, and `63.6%` for `21-50`), suggesting that the `1-5` segment's lower conversion (`49.2%`) is driven more by budget/value sensitivity than onboarding drop-off alone.
3. **Trial Start Cohort / Product Changes Over Time:**
   * Conversion rates declined from Q1 (`59.5%-72.2%`) to July-August (`41.7%-49.1%`). If onboarding UI or traffic quality shifted mid-year, cohort timing could confound the aggregate onboarding comparison.
4. **Selection Bias (Self-Selection):**
   * `onboarding_completed` is a binary flag (`True`/`False`) without a completion timestamp (`onboarding_completed_at`). We cannot verify whether users finished onboarding *before* deciding to convert or completed setup steps *after* purchasing.
