---
name: reference_full_market_screen
description: "每次「幫我選股」固定流程：用TWSE OpenAPI全市場海選(非只漲幅榜)+完整列出使用者所有選股模式,每次都要看到"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 150a22d6-ffb5-49db-8b24-b1d5c57d974f
---

**(2026/06/17使用者定，鐵則)** 每次「幫我選股」必做兩件，缺一不可：

## 一、全市場海選（不是只看漲幅榜/觀察名單！）
用 **TWSE OpenAPI 一次撈全上市股**，PowerShell 本機篩。🔴**用 `New-Object System.Net.WebClient` + `.Encoding=UTF8` + `DownloadString` + `ConvertFrom-Json`**（直接 `Invoke-RestMethod` 中文會變亂碼！`[Console]::OutputEncoding=UTF8`）。端點：
- 本益比/殖利率/PB：`https://openapi.twse.com.tw/v1/exchangeReport/BWIBBU_ALL`（欄 Code/PEratio/DividendYield/PBratio，約1078檔）
- 今日價量漲跌：`https://openapi.twse.com.tw/v1/exchangeReport/STOCK_DAY_ALL`（Code/Name/ClosingPrice/Change/TradeVolume；漲幅%=Change/(Close−Change)×100；量張=TradeVolume/1000）
- 月營收年增：`https://openapi.twse.com.tw/v1/opendata/t187ap05_L`（公司代號＋「營業收入-去年同月增減(%)」）
- 三大法人(外資/投信)：`https://openapi.twse.com.tw/v1/fund/T86`（⚠️**收盤後傍晚才更新**，白天抓回 String/空→當下無籌碼就標註、或等傍晚重跑）
- 排除：非4碼、`^00`(ETF)、`^28`/`^58`(金融金控)。⚠️只含上市；上櫃(OTC)要另用 TPEx API(www.tpex.org.tw)。
- 預設飆股條件(可依使用者調)：月營收年增>30% ＋ 今日漲1–8%(非漲停) ＋ 量>1500張 ＋ PE10–40 ＋（T86有就加）外資買超。高營收年增常是低基期/通路傳產，要分辨質地。

## 二、完整列出使用者的「所有模式」（他每次都要看到，不可省略/不可只給結論）
1. **大盤儀表板**：加權點數、三大法人、乖離率→折扣係數(×1.0/0.7/0.5/0.3)
2. **五區塊全列**(無標的也要寫「本日無」)：🔴事件短打／🔍潛伏層／🔥主升段補漲／🟡確認層／🟢趨勢跟蹤（見[[feedback_stock_selection_system]]）
3. **進場前5題檢查清單**逐檔打勾（集中度/位置/題材/籌碼/紀律，見[[reference_stock_entry_checklist]]）
4. **兩桶資金**(穩定桶70%/飆股桶30%)、**集中度**(同主題≤40%、00981A別加、持倉台積電)
5. 輸出用**純文字、不要表格框框**（見[[feedback_copy_friendly_plaintext]]）

🔴一句話：選股=全市場OpenAPI海選 → 套五區塊評分 → 逐檔過5題清單 → 純文字呈現，模式全列給他看。
