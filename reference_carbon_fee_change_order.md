---
name: reference-carbon-fee-change-order
description: 內部碳費基金修改單範式(每案每年一次、非業變淨0預算平衡、工程專案主管核決)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2e0ecc4d-2dee-4fc7-99db-a768616a42a7
  modified: 2026-07-27T02:29:21.611Z
---

公司「內部碳費徵收與碳費基金管理辦法」每年公告各工程專案應繳碳費（附件1「各工程專案115年度應繳納之碳費金額」表，依範疇1+範疇2溫室氣體排放量核算），需開修改單把碳費列進預算。**會逐案、逐年重複**（附件1同表~24個專案，如AP7P1 FAB 162,573／AP7P1 OFFICE 71,764／AP6B OFFICE 7,776…），碰到直接套此範式。

範式（115.07.27 141A-154 首例定版，承辦林庭安）：
- 性質＝**非業主變更、純預算調整、淨額0**（不套經理業變打法，用舊一二三四五公式）
- 追加「內部碳費基金(工料編號WZ600000000)」X元、由未使用之既有預算項目追減X元平衡（141A-154是拿「#8鋼筋續接器-加長費」數量差追減71,764）
- 廠商欄放「(預算)」；日期＝當天；署名羅慶人
- 第一行括弧＝核決分類「既有單價追減、新增項目議價」（依[[feedback_hangtong_existence_gate]]鄰居R44：只填分類名不寫工項）
- 🔴核決層級＝**工程專案主管◎決**（淨0預算平衡；且加帳<20萬新增項目議價也是工程專案主管，無二擇一）；會辦成本管理部、營運規劃處
- 碳費金額務必對「附件1該專案該年那格」，141A=台積電AP7P1 **OFFICE**（別抓成AP7P1 FAB）
- 串聯：修改審查說明本(新分頁+總表)＋當月計價修改追蹤報表(修改單分頁+合計列)，見[[feedback_status_sync_five_places]][[reference_monthly_tracking_report]]

相關：[[reference_change_order_template]][[reference_approval_authority_table]]
