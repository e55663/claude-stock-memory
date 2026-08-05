---
name: feedback-chinese-string-powershell-traps-0804
description: 115.08.04 兩個隱蔽的中文字串踩雷——手算 \u escape 打錯字、無 BOM 的 .ps1 被當 ANSI；含名稱預檢與腳本中斷善後三步
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 463d84a6-acb5-481d-aa63-63fa2839ecf5
  modified: 2026-08-05T08:32:38.549Z
---

115.08.04 跑 30 件核准歸檔時連踩兩雷，兩雷共同點是**錯得很隱蔽，錯誤訊息看不出病根**。已寫進兩本打法說明 A193、回測加 4 個測項。

**① 絕不手算 Unicode `\uXXXX` escape**
我把 Excel 分頁名用 `\u` 轉義寫進 JSON，把「金鈺昌」的鈺打成鑫（寫 `鑫`，正確 `鈺`）、「竣葦」兩字也錯。症狀＝`Worksheets.Item()` 丟 `DISP_E_BADINDEX (0x8002000B)`，而且 28 個分頁裡 25 個命中、只有 3 個沒中，看訊息完全猜不到是打錯字。
做法＝中文一律用**原字**寫進 UTF-8 資料檔（JSON/CSV），程式用 `[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8)` 讀。任何情況都不准自己轉 `\uXXXX`。

**② PowerShell 5.1 讀無 BOM 的 .ps1 會當 ANSI**
用工具寫出來的 .ps1 是無 BOM UTF-8，PS 5.1 照系統 ANSI 碼頁解讀 → 中文字面值壞掉，症狀是 ParserError「The string is missing the terminator」。這**不是語法錯**，很容易往錯方向修。
做法＝執行前一律補 BOM：
`$t=[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8); [IO.File]::WriteAllText($p,$t,(New-Object Text.UTF8Encoding $true))`
或把中文全部移出腳本、只放資料檔。延伸自 [[feedback_ps_chinese_literal_encoding]]。

**Why:** 這兩個錯都不會讓我當場知道「是我打錯字」，只會丟一個看似環境問題的例外，浪費一整輪除錯，嚴重時還可能寫壞使用者的檔案。

**How to apply:**
- 批次動 Excel 前先跑**名稱存在性預檢**：要用到的分頁名/單號全部先對一遍，全命中才開始寫，任一不中就中止。這是把 A191「超連結目標分頁存在性檢查」擴大到所有批次作業；本次就是靠預檢在寫入前抓到那 3 個錯字，沒寫壞任何資料。
- **腳本中途 throw 的善後三步**：①用 `Downloads\agent\計價回測工具\_清Excel殘留.ps1` 只關無視窗程序（絕不無差別 Stop-Process，見 [[reference_excel_com_scan_pitfalls]]）②原檔 SHA256 跟動手前的備份比對，確認沒被寫壞③確認後才重跑。本次中斷點在 SaveAs 之前，兩本計價本 SHA256 與備份相同＝未受損。
- 另踩到的小雷：`$xl.CutCopyMode = 0` 在 typed interop 會丟列舉轉型錯；改用 `Range.Copy($destination)` 形式，不會留下 CutCopyMode 狀態。

🔴🔴(115.08.05 同一個雷自己又踩一次) 寫 `_總表操作函式庫.ps1`／`_批次歸檔.ps1` 兩支新腳本時，把函式名／變數名全部取成中文（如 `Insert-總表Sorted`、`$區塊`），Write 工具存檔沒有 BOM，PowerShell 5.1 當 ANSI 讀，兩支腳本語法全爛掉（30+ 條解析錯誤）。**教訓不是「記得補 BOM」——那條早就在這份記憶裡，我還是忘了先檢查——而是把命名習慣改掉**：往後任何 .ps1 的函式名／變數名一律純 ASCII（英文），中文只留在註解、字串字面值、雜湊表的值裡；這樣就算 BOM 又出包，頂多是 `Write-Host` 印出來的中文訊息亂碼，不會讓整支腳本連語法都解析不了——**用命名規則把這個雷的殺傷力封頂，比每次提醒自己「記得檢查 BOM」更可靠**。修法：`[System.IO.File]::WriteAllText($p, $content, [System.Text.UTF8Encoding]::new($true))` 補 BOM 後用 `[System.Management.Automation.Language.Parser]::ParseFile` 靜態語法檢查，不要用眼睛掃過去就當作沒事。

相關：[[feedback_never_mix_bash_powershell_file_ops]]、[[reference_powershell_variable_case_trap]]
