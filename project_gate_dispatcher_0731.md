---
name: project-gate-dispatcher-0731
description: "115.07.31 把三支每輪無條件噴的 UserPromptSubmit 提醒 hook 改成模式偵測+黏著的 gate-dispatcher,省額度"
metadata: 
  node_type: memory
  type: project
  originSessionId: fc91bab7-c6e2-4b8a-a156-ddcaef3c9db2
  modified: 2026-07-31T01:36:52.932Z
---

115.07.31 改的：原本 `completeness-gate.ps1`(240字) + `co-rule-gate.ps1`(307字) + `stock-gate.ps1`(1,724字) 三支掛在 UserPromptSubmit，**每一輪無條件全噴 2,271 字**，跟當下在做什麼無關。做請款那天照樣吃 1,724 字的選股閘門；60 輪的 session 等於 10 萬 token 純浪費，而且把 context 撐爆、提早觸發壓縮，把真正要留的查核細節擠掉。

改法：新增 `C:\Users\Seal_Lo\.claude\hooks\gate-dispatcher.ps1`，settings.json 的三支合併成這一支（`session-time.ps1` 不動）。它**不含任何閘門文字**，只做判斷後呼叫原本那三支，所以閘門內容零風險。

四層設計：
1. 偵測 — 掃這輪 prompt（含貼進來的檔案路徑）比對兩組關鍵字
2. 黏著 — 命中一次就寫進 `hooks\state\<session_id>.txt`，整場維持開啟，之後打「好」「那第三件呢」也不會關
3. 手動開關（壓過自動判斷）— `股票模式` / `工作模式` / `閘門全開` 開；`關股票` / `關工作` 關
4. fail-open — stdin 解析失敗或出任何例外，一律三個全噴＝退回改版前行為，絕不會比原本少

兩個刻意避開的誤觸（回測有測項守著）：
- 股票關鍵字**不放單一「股」字**，否則「銘亮股份有限公司」會誤觸
- 股票關鍵字**不放「台積電」**，因為計價本檔名就叫 `01.計價-141A 台積電AP7P1-Office.xlsx`

回測 `hooks\_dispatcher-backtest.ps1`，25 項 25 PASS，該場省 62.5%。**規則一改測項要跟著加**，否則假 PASS（同 [[feedback_backtest_discipline]]）。
`hooks\state\dispatch.log` 每輪記一行判斷結果（只寫檔不輸出，token 成本 0），判錯了回頭查這裡。

🔴 未解：`co-rule-gate.ps1` 第2行仍寫「新增項目議價 20~100萬/100~300萬=執行副總」，與最高位階的 [[reference_approval_authority_table]]（工地流程沒有執行副總這關）衝突，等於每輪餵一條已被推翻的規則。已回報，使用者尚未裁示，**我沒動它**（[[feedback_only_do_whats_asked]]）。

省額度其他手段見 [[feedback_session_cost_and_memory_slimming]]、[[reference_scanned_audit_cost_and_toolchain]]。
