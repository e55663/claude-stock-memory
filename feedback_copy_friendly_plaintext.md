---
name: feedback_copy_friendly_plaintext
description: "要給使用者複製的內容(選股/回報/memo)用純文字條列,不要markdown表格(框框),複製到LINE/Word才不跑版"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 150a22d6-ffb5-49db-8b24-b1d5c57d974f
---

**(2026/06/17)** 使用者會把我的輸出**整段複製**去貼（LINE／Word／郵件）。**markdown 表格（框框）一複製就跑版**。

**How to apply:** 凡是使用者可能要複製的內容（選股分析、比較、回報、呈核memo等）→ **用純文字條列**：
- 標題用 `名稱（說明）`、項目用 `・` 或 `1. 2. 3.`、分隔用一排 `─`。
- **不要用 `|` 表格**；**也少用 `**粗體**`**（複製成純文字會留下星號）。要強調就用「」、全形或直接把關鍵字講清楚。
- 數字、emoji（✅❌）複製沒問題。

預設：選股/回報就直接給這種純文字版，不用等使用者再要求。關聯 [[feedback_no_standalone_artifacts]]（同樣是「以使用者實際使用方式為準」）。
