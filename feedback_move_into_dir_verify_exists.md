---
name: feedback_move_into_dir_verify_exists
description: 搬檔進新夾前必先確認資料夾真的建成功，否則Move到不存在路徑會變改名+被Force覆蓋造成資料遺失
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 91c01c30-8c20-4d69-afea-9c0a5a23948d
---

🔴**(2026/06/22 我害使用者掉一個來源檔)** 要把多個檔搬進「新建資料夾」時，**先確認資料夾真的建成功，再 Move-Item**；對同一個目的地路徑連續 `Move-Item -Force` 之前要確定那是「資料夾」不是「不存在的路徑」。

**踩雷經過：** 我寫 `New-Item -ItemType Directory -LiteralPath $dst`——PowerShell 5.1 的 **New-Item 不吃 `-LiteralPath`（要用 `-Path`）**，所以建夾靜默失敗、$dst 仍不存在。接著兩行 `Move-Item fileA -Destination $dst` / `Move-Item fileB -Destination $dst -Force`：因為 $dst 不存在，PowerShell 把它當成「目標檔名」→ fileA 被改名成 $dst，fileB 帶 `-Force` 直接把剛改名的 fileA **覆蓋蓋掉**。結果只剩一個檔、fileA 內容永久遺失（覆蓋寫入不進回收桶、無法救回）。

**How to apply:**
- 建夾用 `New-Item -ItemType Directory -Path $dst`（不是 -LiteralPath）；建完 `Test-Path -LiteralPath $dst` 確認存在再搬。
- 或乾脆 `if(-not(Test-Path -LiteralPath $dst)){ New-Item -ItemType Directory -Path $dst }` 後加一行驗證。
- Move-Item 進資料夾時，目的地用「已存在的資料夾路徑」；**絕不對不確定存在的路徑連續 Move-Item -Force**（-Force 會無聲覆蓋）。
- 多檔搬移前先列出要搬的清單、搬完逐一驗證「整理夾內有、根目錄沒有」。延續 [[feedback_stage_in_downloads_before_archive]] 的搬移驗證紀律。
