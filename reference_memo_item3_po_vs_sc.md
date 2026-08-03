---
name: reference-memo-item3-po-vs-sc
description: memo 第3點「本期項目」PO 與 SC 分流——PO 只寫品名數量、SC 才寫數量x單價=金額
metadata: 
  node_type: memory
  type: reference
  originSessionId: 8630909a-8c12-49ce-905c-634babdaf80c
  modified: 2026-08-03T06:20:49.940Z
---

memo 第3點「本期項目」的寫法依單號類型分流（115.08.03 定）：

- **PO 合約案**：只寫「品名（含部位／規格／材料表代號）＋數量＋單位」，**不寫單價金額**。單價已被合約明細表框死，memo 重列沒有意義。
- **SC 零星案**：寫「品名＋數量x單價/單位＝金額」。SC 單價是議過的／新的，要當往後的議價基準。

判準看 C 欄單號：`141x-PO`＝合約、`141x-SC`＝零星。

**Why:** 使用者 115.08.03 同一天丟回兩份定版 memo，正好是對照組——141A-PO003395 聖志#7 把單價金額全部拿掉、141A-SC012048 雜支一#1 保留。全庫掃描驗證：PO 案 6/6（竟元#1、呂發#7、金鈺昌開挖面#10、柏林#3、朋洋#8、聖志#7）全部只有品名數量；SC 案 6/6（金鈺昌樓梯#1、揚弘#1、祥竹#11、勝鈞#2、上展#1、雜支#1）全部有單價金額。

**How to apply:** A134①「第3點要寫數量x單價=金額」自此**限縮為只適用 SC**。M 月追蹤報表「請款項目」欄不分 PO/SC 一律維持 A107 完整格式（那欄用途是議價基準對照表，跟 memo 不同），所以 A174「memo 第3點與請款項目欄講同一件事」在 PO 案放寬成「品名與數量對得上即可」。例外不推翻本條：適燁#1(SC011941)、潤泰#1(SC012023) 兩件 SC 沒單價金額，是 A134 定案前後的舊件，依 [[feedback_rules_forward_only_no_retro_edit_0730]] 不回頭改。已寫入兩本打法說明（141A 第187列、141E 第194列）。相關：[[reference_billing_memo_standard_template]]、[[reference_billing_item_column_format]]、[[reference_po_vs_sc_pricing]]、[[feedback_user_edit_implies_rule_0730]]
