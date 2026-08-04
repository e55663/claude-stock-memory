---
name: reference-excel-com-locale-cast-traps-0804
description: Excel COM 中文 locale 三個轉型雷（NumberFormat 要用本地字串、@格式欄要先轉字串、合計列金額改用 .Formula），以及新月份追蹤報表的建法
metadata: 
  node_type: memory
  type: reference
  originSessionId: 463d84a6-acb5-481d-aa63-63fa2839ecf5
  modified: 2026-08-04T07:15:46.751Z
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

**Why:** 這三個都會讓人往合併儲存格、工作表保護、範圍越界的方向查，實際病根在語系與型別繫結。

**How to apply:**
- 判斷方向的通則：`InvalidCastException` 出在 PowerShell 型別繫結那層（先想「這格是不是文字格式」「我指派的型別對不對」）；`1004`／HRESULT 才是 Excel 本身拒絕（才去想合併、保護、語系、範圍）。**看錯層就會查錯方向。**
- 新月份追蹤報表建法（A201，首次執行並回測通過）：複製上月本 → 改 r1 標題與 r2 產出日 → 四個分頁把 r5 到合計列前一列整批 `Rows.Delete()`（保留 r1~r4 表頭與合計列）→ 在合計列**上方** `Rows.Insert()` 插列寫資料（不可往合計列後面加，見 [[feedback_append_row_kills_total_row]]）→ 重算合計列，金額用 `.Formula` 寫。
- 實績：115.08.04 由 7 月本建出 8 月本，寫入 4 件，`_追蹤報表回測` PASS 99／FAIL 0，8 月本被正確認列為「當月本」跑完 T5~T9。

相關：[[reference_excel_com_scan_pitfalls]]、[[feedback_chinese_string_powershell_traps_0804]]、[[feedback_desktop_excel_inplace_save]]
