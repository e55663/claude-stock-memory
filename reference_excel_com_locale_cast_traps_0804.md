---
name: reference-excel-com-locale-cast-traps-0804
description: Excel COM 中文 locale 三個轉型雷（NumberFormat 要用本地字串、@格式欄要先轉字串、合計列金額改用 .Formula），以及新月份追蹤報表的建法
metadata: 
  node_type: memory
  type: reference
  originSessionId: 463d84a6-acb5-481d-aa63-63fa2839ecf5
  modified: 2026-08-05T03:59:42.377Z
---

115.08.04 建 4 件新請款進計價本＋建 8 月追蹤報表時，同一支腳本連踩三次。三個都不是邏輯錯，是型別／語系問題，而且**錯誤訊息全指向錯的方向**。已寫進兩本打法說明 A199／A201。

**① NumberFormat 吃的是「本地」字串**
這台 Excel COM 以中文語系跑，設 `NumberFormat='General'` 丟 1004「無法設定種類 Range 的 NumberFormat 屬性」，正確是 `'G/通用格式'`。
🔴 陰險處：`'@'`（文字格式）兩種語系都通用、設得進去 → 會出現「同一段迴圈設 @ 全成功、只有設 General 失敗」的假象。我先去查 MergeCells 與 ProtectContents（都正常）才回頭想到語系，白花兩輪。
線索：讀既有儲存格會回 `'G/通用格式'` 而不是 `'General'`。

**② 指派值給「文字格式(@)」的儲存格要自己先轉字串**
`.Value2 = [int]$x` 會丟 .NET 端 `InvalidCastException: Unable to cast System.Int32 to System.String`。解法 `[string]$x`。追蹤報表「項次」欄就是 @ 格式。

**③ 合計列金額改用 `.Formula` 寫**
即使先把 NumberFormat 設成 `'#,##0'`，`.Value2 = $double` 仍丟 InvalidCastException；改 `.Formula = ([string]$sum)` 就過，寫進去仍是**數值不是文字**，回測 T7「金額欄無數字存成文字」照樣 PASS。

**④（115.08.05 新增）搬列 `Rows.Cut()` + `Rows.Insert()` 之後，不要碰 `$xl.CutCopyMode`**
`$xl.CutCopyMode=0` 與 `=$false` 兩種寫法在這台都丟 `Cannot convert value to Microsoft.Office.Interop.Excel.XlCutCopyMode`（這台繫結到具型別的 interop 組件，不吃 0／$false，只吃 `xlCopy`／`xlCut` 列舉）。**直接不要寫那一行**——`Insert` 完成後剪貼模式自己就結束了，整列搬移結果正確。
🔴 這行丟例外的殺傷力在於：它排在 `SaveAs` 之前，於是「搬列已經在記憶體裡做完、但整支腳本沒存檔就中斷」，還留下一個看不見的 headless EXCEL 程序。清法：`Get-Process EXCEL | Where-Object { $_.MainWindowTitle -eq '' } | Stop-Process -Force`（只殺沒有視窗標題的＝自動化殘留，有標題的是使用者自己開的不能殺）。

**⑤（115.08.05）搬列後「合計列位置」與「A欄項次起始列」都要重新確認**
`Rows.Item(61).Cut()` 之後 `Rows.Item(64).Insert()`，Excel 是「先刪原列（後面整體上移 1）再插入」，所以合計列位置**不變**（原 64 → 仍 64），不是往下推。硬寫 `$totRow=64` 恰好對，但要驗過再用。
另：追蹤報表資料**從 r5 起算**（r4 是「項次／合約單號…」標頭列）。迴圈寫成 `for($r=4;...)` 會把標頭列當第 1 筆、A4 標頭被覆寫成數字 1，而且件數多算 1 件（59 變 60）——件數對不上就是這個病徵。

**Why:** 這三個都會讓人往合併儲存格、工作表保護、範圍越界的方向查，實際病根在語系與型別繫結。

**How to apply:**
- 判斷方向的通則：`InvalidCastException` 出在 PowerShell 型別繫結那層（先想「這格是不是文字格式」「我指派的型別對不對」）；`1004`／HRESULT 才是 Excel 本身拒絕（才去想合併、保護、語系、範圍）。**看錯層就會查錯方向。**
- 新月份追蹤報表建法（A201，首次執行並回測通過）：複製上月本 → 改 r1 標題與 r2 產出日 → 四個分頁把 r5 到合計列前一列整批 `Rows.Delete()`（保留 r1~r4 表頭與合計列）→ 在合計列**上方** `Rows.Insert()` 插列寫資料（不可往合計列後面加，見 [[feedback_append_row_kills_total_row]]）→ 重算合計列，金額用 `.Formula` 寫。
- 實績：115.08.04 由 7 月本建出 8 月本，寫入 4 件，`_追蹤報表回測` PASS 99／FAIL 0，8 月本被正確認列為「當月本」跑完 T5~T9。

相關：[[reference_excel_com_scan_pitfalls]]、[[feedback_chinese_string_powershell_traps_0804]]、[[feedback_desktop_excel_inplace_save]]
