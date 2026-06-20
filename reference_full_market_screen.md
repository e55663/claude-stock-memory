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
- 三大法人(外資/投信)：OpenAPI `https://openapi.twse.com.tw/v1/fund/T86` 只給「今日」收盤後傍晚才有。🔴**(2026/06/18修正，別再說「資料不足」當藉口)：前一交易日的法人隨時抓得到！用日期端點** `https://www.twse.com.tw/rwd/zh/fund/T86?date=YYYYMMDD&selectType=ALLBUT0999&response=json`（西元日期、加 `User-Agent` header）。⚠️回傳 `data` 是**位置陣列**(非具名)：第0欄證券代號、第4欄外陸資買賣超股數、第10欄投信買賣超股數；值含逗號要 `-replace ',',''`；股數/1000=張。**抓近3個交易日(連續)→判外資/投信「連3買/連3賣」**(連買=核心進場訊號、連賣=出場訊號)。投信連3賣 vs 外資連3買「打架」的剔除。⚠️若白天 OpenAPI 回空，改用此日期端點抓前一日，不要停。
- 季均量(潛伏層「靜置」用)：`https://www.twse.com.tw/rwd/zh/afterTrading/STOCK_DAY?date=YYYYMM01&stockNo=XXXX&response=json` 抓單檔整月日量(data位置陣列、第1欄成交股數)，抓近3個月平均=季均量；今日量/季均≤1=靜置✔、>1.5=已放量✘。只對潛伏候選股算(不用全市場)。
- 排除：非4碼。🆕**(2026/06/20使用者更新三項)**：①ETF(`^00`)納入，推薦時主動ETF標「ETF/主動」、被動指數型標「ETF/被動」（名稱含「主動」或代號末尾英文字母=主動型）；②金融金控(`^28`/`^58`)納入，推薦時標「金融股」；③上櫃(OTC)納入，另用 TPEx API(`https://www.tpex.org.tw/web/stock/aftertrading/otc_quotes_no1430/stk_wn1430_result.php?l=zh-tw&o=json`)補抓，推薦時標「上櫃」。三類推薦都附備註，不再排除。
- 預設飆股條件(可依使用者調)：月營收年增>30% ＋ 今日漲1–8%(非漲停) ＋ 量>1500張 ＋ PE10–40 ＋（T86有就加）外資買超。高營收年增常是低基期/通路傳產，要分辨質地。

## 二、完整列出使用者的「所有模式」（他每次都要看到，不可省略/不可只給結論）
1. **大盤儀表板**：加權點數、三大法人、乖離率→折扣係數(×1.0/0.7/0.5/0.3)
2. **🆕(6/18)八區塊全列**(無標的也要寫「本日無」)：🔴事件短打／🔍潛伏層／🔥主升段補漲／🟡確認層／🟢趨勢跟蹤／🆕多因子海選ABCDE(A月營收/B動能/C價值/D半導體AI/E綜合)／🧭由上而下資金輪動龍頭比價(漲跌家數比率+匯率+資金輪動→領先族群→龍頭→比價補漲)／🎯型態學三面共振(8型態×技術+籌碼+消息+漲幅滿足等幅+葛蘭碧八法則,課程第8堂)，課程來源見[[reference_trading_course_source]]（細節見[[feedback_stock_selection_system]]）
3. **進場前5題檢查清單**逐檔打勾（集中度/位置/題材/籌碼/紀律，見[[reference_stock_entry_checklist]]）
4. **兩桶資金**(穩定桶70%/飆股桶30%)、**集中度**(同主題≤40%、00981A別加、持倉台積電)
5. 輸出用**純文字、不要表格框框**（見[[feedback_copy_friendly_plaintext]]）

🔴一句話：選股=全市場OpenAPI海選 → 套五區塊評分 → 逐檔過5題清單 → 純文字呈現，模式全列給他看。

🔴🔴**執行態度(2026/06/17使用者再強調)**：他一打「幫我選股」就**直接把所有資料全跑出來**，不要先問「要哪個選項/要不要等」、不要丟 1/2/3 menu。**有其他建議＝放在「跑完所有資料之後」再補在最後**，不能用建議/提問取代跑資料。籌碼(T86)若白天 OpenAPI 還沒出，**改用日期端點抓前一交易日法人(見上方)、算連3買連3賣，不要說「資料不足」當藉口**——使用者2026/06/18明確指正過這點。真正抓不到的只有「今天盤中1:20量縮、今天收盤價」這種還沒發生的數據，那才標「需收盤後補」。
