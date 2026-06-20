---
name: feedback-read-files-completely
description: 讀記憶檔/資料檔必須讀完整，不能用 limit 截斷；使用者可以等，寧可慢不要漏
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a8797345-a026-4a2f-8d02-0b43d5dc1857
---

**(2026/06/20 使用者明確糾正)** 讀任何記憶檔或資料檔時，**不能加 `limit` 截斷，必須讀完整個檔案**。

🔴 不能做的：`Read(file, limit=40)` → 只讀前40行 → 漏掉後面的重要資料（本次案例：portfolio_watchlist.md 共104行，limit=40 漏掉第91-96行的0056/00878/00919 ETF換股資料，導致分析不完整）

✅ 正確做法：先不加 limit 讀完整檔案；若檔案真的超大（>500行）才考慮分段，但要主動告知使用者「檔案很長，分兩段讀」，不能靜默截斷。

**Why:** 使用者明確說「我可以等，給我完整的資料」，寧可多花一點時間讀完，不能為了「節省」而漏資料。漏資料造成的分析錯誤成本遠大於多讀幾秒的時間。

**How to apply:** 每次用 Read tool 讀記憶檔（.md）或任何分析用的資料檔時，預設不加 limit，確保讀完整。如果系統回傳「檔案被截斷」才再用 offset 補讀後半段。
