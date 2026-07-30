---
name: reference-twse-api-same-day-data
description: 🔴盤後當日選股不能用 openapi STOCK_DAY_ALL(會停在前一交易日)，要用 RWD MI_INDEX 指定日期；另附 60 日全市場面板自算 DD60、T86 連買、BWIBBU 個股 PE 歷史的正確抓法與限流雷
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7bfe59d6-f454-461e-8d55-a884d957dbc4
  modified: 2026-07-30T09:23:13.437Z
---

115.07.30 17:00 盤後實測（收盤 13:30 早就過了）。

## 🔴 最大的雷：STOCK_DAY_ALL 會停在前一交易日
`https://openapi.twse.com.tw/v1/exchangeReport/STOCK_DAY_ALL`
7/30 16:40 查詢時回的還是 **7/29** 的資料（台積電 close=2200 / chg=−80 正是 7/29 的數字，7/30 實際是 2205 / +5）。它**沒有日期欄位**，不看內容根本發現不了 → 拿它當「今天」會整輪錯。

**正確做法：用 RWD 指定日期**
```
https://www.twse.com.tw/rwd/zh/afterTrading/MI_INDEX?date=YYYYMMDD&type=ALLBUT0999&response=json
```
回傳 10 個 table：價格指數(含類股)、報酬指數、大盤統計、**漲跌證券數合計(家數比)**、以及 `每日收盤行情` 1,373 檔全市場。欄位序：
`0證券代號 1名稱 2成交股數 3成交筆數 4成交金額 5開盤 6最高 7最低 8收盤 9漲跌(+/-) 10漲跌價差 15本益比`
🔴 第 9 欄是 HTML 片段（`<p style= color:red>+</p>` / `color:green`），要用 red/green 判正負號再乘上第 10 欄，不能直接取值。

## 其他端點
- **三大法人 T86**：`https://www.twse.com.tw/rwd/zh/fund/T86?date=YYYYMMDD&selectType=ALL&response=json`（7/30 當天 16:40 已可取得）。欄位序 `0代號 4外陸資買賣超股數 10投信買賣超股數 18三大法人買賣超股數`，單位是**股**，除以 1000 才是張。連 3 買要抓連續三個交易日各跑一次。
- **BWIBBU_d（全市場 PE/PB/殖利率）**：`afterTrading/BWIBBU_d?date=...` 7/30 當日**尚未公布**（回「沒有符合條件的資料」）。替代＝直接用 MI_INDEX 第 15 欄的本益比。
- **BWIBBU（個股 PE 歷史，做題3百分位用）**：`afterTrading/BWIBBU?date=YYYYMM01&stockNo=XXXX&response=json`，一次回該月每日。欄位序 `0日期 1殖利率 2股利年度 3本益比 4股價淨值比`。🔴**我曾取錯欄位**（拿 4 當 PE，結果長榮航跑出「PE 1.30~1.81」這種不可能的數字）——PE 是第 3 欄不是第 4 欄。
- **月營收 t187ap05_L**：`https://openapi.twse.com.tw/v1/opendata/t187ap05_L`，欄位 `公司代號 / 營業收入-當月營收 / 營業收入-去年同月增減(%) / 累計營業收入-前期比較增減(%)`。

## 🔴 限流行為（實測）
- **TWSE**：連續打 200+ 次後開始回 **307 Temporary Redirect**，且是靜默的（部分股票回 n=0 看起來像「沒資料」，其實是被擋）。對策＝每次 request 間隔 ≥0.7~1.5 秒、加 retry backoff、**成功月份數要印出來核對**（例如 12/12），不能只看有沒有拿到值。
- **Yahoo**：連打會回 **429 Too Many Requests**。對策＝間隔 2 秒 + 3~4 次 retry，或改用 `query2.finance.yahoo.com`。

## 🔴 全市場 DD60（距 60 日高回檔）的划算算法
逐檔打 Yahoo 要 1,300+ 次必被限流。改成**抓 60 個交易日的 MI_INDEX 全市場面板**（只要 ~88 次 request、約 2 分鐘），一次得到全市場每檔的 60 日最高價 → DD60 全市場一次算完（實測 1,348 檔）。7/30 用這法跑出漏斗：1,373 → 流動性 551 → DD60≤−23.8% 331 → 營收 YoY>0 220 → 法人連3買 70。
同一份面板留最近 7 天的**最低價**，就能直接掃型②止穩訊號（單日跌≥5% + 5 日內首次當日低未破前日低）。

## 大盤均線／回檔
`https://query2.finance.yahoo.com/v8/finance/chart/%5ETWII?range=6mo&interval=1d` 自算 MA20 / MA60 / 60 日高。🔴距 60 日高有兩個口徑（盤中高 vs 收盤高），差約 0.8 個百分點，要標明用哪個。

相關 [[reference_full_market_screen]]、[[reference_excel_com_scan_pitfalls]]、[[feedback_evidence_required_no_assumptions]]。
