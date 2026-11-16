# Support Ticket & Conversion Analysis

> **Methodology Note:** Completed **16 November 2026** by joining `392` eligible external trials with `support_tickets.csv` (`120` total tickets across `103` unique users; `103` tickets map to eligible external trial users).

---

## 1. Conversion Rate by Support Ticket Category

| Ticket Category | Trial-Ticket Records | Conversions (≤30d) | 30-Day Conversion Rate | Diff vs. No Ticket |
| :--- | :---: | :---: | :---: | :---: |
| **onboarding** | 44 | 28 | **63.6%** | **+8.9 pp** |
| **feature_request** | 17 | 10 | **58.8%** | **+4.1 pp** |
| **no_ticket** *(Baseline)* | 289 | 158 | **54.7%** | — |
| **technical** | 41 | 22 | **53.7%** | -1.0 pp |
| **billing** | 18 | 9 | **50.0%** | -4.7 pp |

* **Key Pattern:**
  * Users who submit **`onboarding` (`63.6%`)** or **`feature_request` (`58.8%`)** tickets convert *above* the no-ticket baseline (`54.7%`).
  * Users with **`billing` (`50.0%`)** or **`technical` (`53.7%`)** tickets convert slightly *below* the no-ticket group.

---

## 2. Open vs. Resolved Tickets

| Ticket Resolution State | Ticket Count | Conversions (≤30d) | 30-Day Conversion Rate |
| :--- | :---: | :---: | :---: |
| **Resolved (`resolved`)** | 64 | 37 | **57.8%** |
| **Open / Pending (`open`, `awaiting_customer`, `escalated`)** | 56 | 32 | **57.1%** |
| **All External Trial Tickets** | **120** | **69** | **57.5%** |

*(Breakdown of open/pending statuses across matched records: `20` open, `19` awaiting_customer, `17` escalated).*

* **Key Pattern:** Overall conversion among ticket submitters (`57.5%`) is slightly higher than users with no tickets (`54.7%`), and there is virtually **no difference** between resolved tickets (`57.8%`) and open/pending tickets (`57.1%`).

---

## Analytical Caveat: Friction vs. Engagement
* **Support contact is an ambiguous signal—it can indicate either product friction or high user engagement.**
  * A user filing a `feature_request` or `onboarding` question is actively exploring Nimbus and investing effort into configuring their workflow (high engagement), which correlates with higher conversion (`58.8%-63.6%`).
  * Conversely, the absence of a support ticket (`289` users, `54.7%` conversion) **does not mean a customer experienced no friction**—many frustrated users quietly abandon the trial without ever contacting support.
* **Additional Limitations:** Sample sizes per ticket category are small (`17` to `44` records), some users submitted multiple tickets (`120` ticket records across `103` users), and `support_tickets.created_at` was not filtered strictly to pre-conversion dates (meaning some `billing` or `feature_request` tickets may have been opened *after* conversion).
