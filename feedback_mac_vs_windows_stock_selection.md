---
name: feedback_mac_vs_windows_stock-selection
description: Mac session 選股 vs Windows session 選股方式不同，使用者要求記住兩者差異並接受兩種都能用
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e7dbd013-1dea-4c3a-bd3b-2d42fbf08538
---

Mac session 與 Windows session 選股方式不同，使用者確認兩種都可接受，但要清楚知道差異。

**Mac session（由上到下，主題驅動）**
- WebFetch 抓 TWSE JSON（STOCK_DAY_ALL / BWIBBU_ALL / T86）+ WebSearch 找新聞催化劑
- 先找市場主題/事件 → 再找對應標的 → 套十區塊分析
- T86 法人資料通常不完整（TWSE API 只回傳部分）
- 沒有 stock-gate.ps1 hook 強制，靠 memory 自律跑程序
- 對帳紀錄.txt 在 Windows 桌面，Mac 無法存取，暫存進 memory

**Windows session（由下到上，全市場海選）**
- PowerShell 腳本 → TWSE OpenAPI 全市場 1,787 檔一次拉（BWIBBU_ALL + STOCK_DAY_ALL + T86）
- 系統性全量過濾 → 再套十區塊
- T86 完整，法人連買連賣閘門可正式過
- stock-gate.ps1 hook 強制對帳段、強制閘門

**How to apply:**
- 在 Mac session 不要硬裝作跟 Windows 一樣（全市場掃描沒有資料支撐）
- Mac session 用主題驅動補強可以、結果仍輸出十區塊格式
- 籌碼閘門(第4關)在 Mac 永遠打折，明確說明
- 到 Windows session 才能跑完整流程，選股對帳紀錄.txt 在 Windows 補登
