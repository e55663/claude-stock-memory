---
name: feedback_backtest_blindspots_0807
description: 115.08.07抓到四個「回測/hook自己的盲區」造成假PASS:修改單本沒被A層驗到、案夾pattern認不出新命名、hook可用-File繞過、記憶整併後清單沒更新
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 21699ced-3a5b-47b3-ae16-830cbb7d012f
  modified: 2026-08-07T01:57:33.065Z
---

回測與 hook 全綠不代表沒事——0807 一次抓到四個「工具自己看不到的地方」，全都是假 PASS。

**Why:** 使用者 0805 做了打法說明壓縮＋記憶瘦身，之後兩支 A 層回測仍全 PASS，但實際上規則掉了、新夾沒被驗到、hook 被繞過。共同病根是**回測的涵蓋範圍寫死在「當初想到的那個檔/那個格式」，來源一改就變睜眼瞎**。

**How to apply:**

1. **A 層回測只讀計價本，修改單本從沒被驗過** — `_規則同步回測.ps1` 與 `_精簡版覆蓋率回測.ps1` 都只開 `01.計價-*.xlsx` 的「請款單打法說明」，`02.修改審查說明-*.xlsx` 的「修改單打法說明」完全不在掃描範圍。結果 0805 壓縮把「業變經理打法逐字標準範本」(國廣車道鋼板樁 115.07.07 定版)整條弄丟，兩支回測照樣 136/136 全 PASS。已補 `_規則同步回測.ps1` 的 **T6 段**(兩本修改單本條文數一致＋19 個核心關鍵字)，並把範本補回兩本 ■九。
   - 反例實證：拿 0805 壓縮後的原始檔跑 T6 → 19 項中 9 項 FAIL，前 3 項正是被壓縮掉的範本。
   - 通則：**壓縮/搬移任何規則檔後，先問「哪支回測看得到這個檔」，看不到就是缺口，當場補**。

2. **`_案件執行回測.ps1` 的夾名 pattern 認不出新版修改單命名** — 舊 pattern 寫死 `^(141A|…)、` 要求工地代號後接頓號，但修改單 115.07.01 起改成 `141A-138(業變)項目(廠商)-修改單`(接的是 `-`)。三個新修改單夾一個都沒被掃到，就算沒建查核記錄也不會被抓。修好後案夾數 18→24，還多抓出 141A-116、141A-144 兩個舊夾缺查核記錄。單號後可能帶🔴標記，用 `-\d+\S*\(.+\)-修改單` 放寬。
   - 通則：**改了命名規則，要同步檢查所有用夾名 regex 篩選的腳本**。

3. **hook 可以用 `-File` 整個繞過** — `excel-save-guard.ps1` 只檢查 `tool_input.command` 字串本身。跑 `powershell -File "…\write_memo.ps1"` 時命令裡沒有 `SaveAs`/`.Workbooks.` 字樣 → 第一道 notmatch 直接放行，腳本內的裸 `SaveAs($path,51)` 照樣蓋掉桌面原檔。已改：把命令引用的 .ps1(`-File` / `&` / `.` 三種寫法)讀進來一起檢查。
   - 第二個坑：改成讀檔後，用 regex 會把腳本裡的**規則說明文字**(如「絕不裸SaveAs/裸.Save()」)誤判成真的呼叫而誤擋合規腳本。改用 **AST**(`InvokeMemberExpressionAst`)只認真正的方法呼叫，註解與字串字面值一律不算。
   - 反例實證 7/7：違規(-File含裸SaveAs／命令列裸SaveAs／裸.Save())全擋、合規(原地覆寫法／含規則文字的腳本／只讀不存／沒碰Excel)全放行。
   - 通則：**hook 擋的是「命令字串」，任何把邏輯藏進檔案的執行方式都是潛在繞道**。

4. **記憶整併後回測清單沒跟著更新，產生 10 項假 FAIL** — `_規則同步回測.ps1` T3 硬列記憶檔名，0805 整併掉 5 個檔後全數報「檔案不存在」。已逐檔查證整併去向後改指合併檔，原檔名留在註解供追溯：
   - `feedback_chinese_string_powershell_traps_0804` → `reference_excel_ps_traps_0806`(第四節)
   - `reference_excel_com_locale_cast_traps_0804` → `reference_excel_ps_traps_0806`(第三節)
   - `reference_archive_move_zone_rule_0804` → `reference_archive_workflow_0806`
   - `feedback_own_work_backtest_caught_errors_0804` → `feedback_backtest_discipline`
   - `feedback_add_payment_no_signature_required` → `reference_attachment_checklist_0806`(L46-47)
   - 🔴過程教訓：我一度以為「加款免簽名」規則內容遺失，實際是**我的搜尋詞寫太窄**(原文是「加款類不強制雙方簽名」)。呼應 [[feedback_backtest_discipline]]「回測報 FAIL 時先懷疑是不是檢查腳本自己寫錯」——查證要用寬鬆詞多試幾個，別憑一次 grep 落空就宣告資料遺失。

**待辦(未做，等使用者裁示):** `_案件執行回測.ps1` 目前 10 個 FAIL 全是既有舊案夾缺查核記錄.txt(五金翔盛#6、弘隆#12、SGS#12、天九#1、亦鑫#11、齊昇修改單、國廣修改單、141A-116、141A-144)，補這些要重新審那些案子，多數已送出/已歸檔屬舊件。

相關：[[feedback_backtest_discipline]]、[[reference_excel_ps_traps_0806]]、[[feedback_change_order_follows_billing_logic_0807]]、[[feedback_memory_manual_format_0805]]
