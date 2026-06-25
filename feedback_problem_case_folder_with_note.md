---
name: feedback_problem_case_folder_with_note
description: "有問題/缺件的請款案→把資料整理進一個資料夾(請款命名規範),資料夾外面放「🔴問題標註.txt」列缺件/抓錯;仍只在Downloads staging不搬工地"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 117e8633-e808-48e9-8629-e20557d9b73c
---

(2026/06/25 定)當某件請款/案件有問題(缺件、抓錯、暫緩)時,除了口頭回報,還要**實體整理**:

1. 在 Downloads 建一個整理夾,夾名=請款命名規範(工地、類別、項目(廠商)#期數-請款單 計價月),把該案所有來源檔(列控表/合約/請款單/發票/PDF等)搬進夾內。
2. 在資料夾**外面**(Downloads 同層、與夾並列)放一個純文字檔「<同夾名> — 🔴問題標註.txt」,列出:狀態(暫緩/勿送呈)、🔴/🟠 問題逐條(附出處)、還缺哪些附件、已完成什麼、核決層級、補齊後的下一步。目的=不用打開夾就一眼看到哪裡卡關。
3. 🔴 這仍是 staging,不是歸檔:只放 Downloads,**不搬工地**,等使用者明確說「歸檔」才搬 [[feedback_stage_in_downloads_before_archive]]。

執行紀律:
- 建夾用 `New-Item -ItemType Directory -Path`(PS5.1)+ `Test-Path` 驗證存在再搬;搬檔 `Move-Item -LiteralPath` 不加 `-Force`(避免覆蓋),搬完驗夾內有/原位無 [[feedback_move_into_dir_verify_exists]]。
- 中文夾名/檔名與 .txt 內容用 Write 寫 .ps1 → 補 UTF8-BOM → 執行,避免編碼壞 [[feedback_ps_chinese_literal_encoding]]。
- 問題標註內容延續 todo 寫法但改放夾外 txt(不再只塞 docs/todo.md)[[feedback_batch_todo_workflow]];純文字條列、複製友善 [[feedback_copy_friendly_plaintext]]。

**Why**:使用者要一眼辨識哪個資料夾有問題、且資料先收整齊不散落,省他翻找時間。
**How to apply**:任何請款/案件核對出缺件或錯誤時,自動做「整理進夾 + 夾外問題標註.txt」,不用等他開口。
