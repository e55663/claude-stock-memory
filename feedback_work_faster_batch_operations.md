---
name: feedback_work_faster_batch_operations
description: 使用者嫌我做事太慢:Excel操作別拆多支腳本來回、給了最終文字就直接做別再問、一次讀多檔
metadata: 
  node_type: memory
  type: feedback
  originSessionId: aa6a4d5b-2223-43f9-aeca-85bdf9edbc61
---

**(2026/06/23 使用者明講)** 「我發現你效率很慢欸，我自己改還比較快，可以不要這樣嗎」＋多次「快快快」。我的毛病＝把一件事拆成太多「寫腳本→補BOM→run」的來回，還一直問確認。

**Why:** 使用者做工地行政要快，來回浪費他時間（也燒額度）；他已經把最終答案/文字給我時，再問就是拖。

**How to apply（往後一律）:**
- 能合併的 Excel 操作寫進**一支腳本一次做完**（讀＋改＋存後驗證），別拆成多支來回跑。
- 使用者已給**最終文字或決定**就直接動手，別再問「要不要」。
- **一次讀多檔**：PDF 用 Read、xlsx 用一支 COM dump，並行丟出去，別逐檔來回。
- 動手前先盤點「這任務要碰哪些檔／哪些格」，湊成**最少次工具呼叫**再出手。
- 🔴 中文 COM 腳本可靠作法（本 session 全程驗證）：用 Write 把 .ps1 寫成 UTF-8 → 一條無中文的指令補 UTF8 BOM（`[System.IO.File]::WriteAllText($p,$c,(New-Object System.Text.UTF8Encoding($true)))`）→ `powershell -File` 執行。避開 inline 手打中文編碼壞（見 [[feedback_ps_chinese_literal_encoding]]）。
- 改檔流程仍守安全（[[feedback_delete_temp_backups]]）：腳本內先 Copy-Item 備份→SaveAs($path,51)→存後讀回驗證→驗OK單行刪備份。只是「次數要少、一支搞定」。

延續 [[feedback_batch_todo_workflow]]（一批檔跑完問題集中 todo.md）。
