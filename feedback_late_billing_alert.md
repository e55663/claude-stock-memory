---
name: feedback_late_billing_alert
description: 請款單月份距今超過3個月就主動提醒使用者「請款太晚不合理」
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 150a22d6-ffb5-49db-8b24-b1d5c57d974f
---

處理/歸檔/審核請款單時，看檔名或單據裡的**請款月份**（民國格式如 `115.06` = 2026/06），跟「今天」比：
- **請款月份距今 > 3 個月 → 主動提醒**使用者「這筆是 N 個月前的款，現在才請不太合理」，並打出固定提醒語：
  > **建議廠商施作完成，三個月內幫廠商請款。**
- 例：現在是 6 月（115.06），還在請 1～3 月（115.01~115.03）的款 → 點出來＋打上面那句。
- 3 個月內（如 6 月請 4~6 月）算正常，不用特別講。

**Why:** 廠商太晚才送請款是異常訊號（可能漏請、補請、或有爭議），使用者要早點知道去追。
**How to apply:** 每次經手請款單就順手算月份差，超過就主動講一句，不用等他問。配合 [[reference_invoice_audit_context]]、[[reference_site_archive_convention]] 一起用。
