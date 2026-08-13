---
name: reference-twse-api-same-day-data
description: 🔴盤後當日選股不能用 openapi STOCK_DAY_ALL(會停在前一交易日)，要用 RWD MI_INDEX 指定日期；另附 60 日全市場面板自算 DD60、T86 連買、BWIBBU 個股 PE 歷史的正確抓法與限流雷
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7bfe59d6-f454-461e-8d55-a884d957dbc4
  modified: 2026-08-13T07:29:29.033Z
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

## 🔴🔴 115.08.11 新增：BWIBBU_ALL 會「無聲吃掉」date 參數
`afterTrading/BWIBBU_ALL?date=YYYYMMDD&response=json` — **date 參數完全無效，不管填哪天都回最新一個交易日**。實測抓 20260615 / 20260701 / 20260810 三個日期，三個檔案 SHA256 **完全相同**，內文 `title` 都是「115/08/10」。
→ 我 0811 差點拿它做「7/1 vs 8/10 本益比比較」，跑出「每一檔 PE 前後一模一樣」的荒謬結果才發現。**任何歷史 PE/PB 比較一律用 `BWIBBU_d`**，它的 date 是真的有效（回傳 `date` 欄與 `title` 會跟著變）。
- `BWIBBU_ALL` 欄位序：`0代號 1名稱 2本益比 3殖利率 4股價淨值比`
- `BWIBBU_d` 欄位序（**不一樣，別套錯**）：`0代號 1名稱 2收盤價 3殖利率 4股利年度 5本益比 6股價淨值比 7財報年/季`
- 🔴 `7財報年/季` 很有用：能看出 PE 分母是哪一季。**8 月財報季一過，全市場 PE 分母整批從 Q1 換成 Q2，PE 會集體機械性下修**，跟股價跌不跌無關（見 [[reference_pe_compression_not_oversold_0811]]）。
- ⚠️ 個別日期會出現異常值（2327 在 20251114 回 PE 5.71 / PB 0.74，與前後差一個量級）→ 建歷史區間時要肉眼掃一遍剔除離群值，別直接算統計量。

## 🔴 剛收盤（13:30~15:00）EOD 還沒入庫時怎麼辦
0811 13:32 實測：`MI_INDEX`（當日）、`T86`、`BFI82U` 全部回空，只有前一交易日有資料。
- 大盤即時：`https://mis.twse.com.tw/stock/api/getStockInfo.jsp?ex_ch=tse_t00.tw&json=1&delay=0&_=<ms>` → `z`現價 `y`昨收 `o`開 `h`高 `l`低 `t`時間。
- 全市場即時：同一支 API，`ex_ch` 用 `|` 串接，**一次最多約 45 檔**，1,087 檔約 24 批、間隔 250ms 跑得完。`v`＝累積成交量（張），成交金額只能用 `v×1000×z` 近似，要標明是近似值。
- 🔴 這種日子的漲跌家數是自算的代理值（0811 自抓 1,087 檔得 380漲/607跌=0.63），**必須標明「官方家數未出」**，不能當官方數字報。

## 🔴 股票簡稱後面的「*」＝彈性面額，不是處置股
國巨*、可寧衛*、愛普* 這種。證交所加註「*」代表**該公司面額不是新臺幣 10 元**（彈性面額制度），跟處置股、分盤交易、全額交割**完全無關**。0811 我誤寫成「處置股分盤交易」被自己查證推翻，已更正紀錄檔。處置股要查證交所「處置有價證券」公告，不能看名稱猜。

## 🔴 PowerShell 5.1 跑這些腳本的三個雷（0811 各踩一次）
1. **Write 工具寫出的 .ps1 是無 BOM UTF-8，PS 5.1 會用 ANSI 讀 → 中文全毀、引號被吃、報「missing terminator」**。對策：寫完先轉存成帶 BOM 再執行 —
   `$t=[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8); [IO.File]::WriteAllText($p,$t,(New-Object Text.UTF8Encoding $true))`
2. **`if` 不能當運算式內嵌**（`-f ... ,(if($x){a}else{b})` 直接報 CommandNotFound）。要先算進變數再用。
3. **變數名大小寫不分**：`$A=@()` 會蓋掉前面的 `$a` 雜湊表，錯誤訊息是「[Object[]] does not contain ContainsKey」。用了 `$a/$b` 就別再用 `$A/$B`。

## 🔴🔴 115.08.13 新增：財報三支（做估值一定要用，比 PE 欄可靠）
8 月財報季期間**每天都在變**，抓之前先看 `出表日期` 與 `年度/季別`：
- `opendata/t187ap17_L`（營益分析）：欄位 `年度 季別 公司代號 營業收入(百萬元) 毛利率(%) 營業利益率(%) 稅前純益率(%) 稅後純益率(%)`
- `opendata/t187ap06_L_ci`（損益表）：最有用的是 **`基本每股盈餘（元）`**，Q2 那筆＝**H1 累計 EPS**（不是單季）
- 0813 實測：兩支出表日 1150813、已更新 **115Q2 但只有 594 檔**（8/14 才是截止日，台積電等大型股當天還沒進表）→ **母體會缺，別以為是篩掉的**。
- 🔴 **年化PE ＝ 收盤 ÷（H1 EPS × 2）**，要跟 TWSE 官方 PE（BWIBBU_d 分母當時多半仍是 115Q1）**分開列**，兩個口徑一起看才不會被換分母騙。
- 🔴 **一次性損益要靠 ap17 抓**：稅後純益率遠高於營業利益率＝業外灌水（0813 抓到偉詮電、研揚、聯電、新興）。力積電 2026Q1 EPS 3.36 幾乎全是賣 P5 廠給美光的處分利益、本業僅約 5 億，就是這型；只看 EPS 會嚴重高估。
- 產業別欄要去 `t187ap05_L` 拿（ap17/ap06 沒有），排除字串用 `-like '金融*'`、`-like '建材營造*'`。

## 🔴 限流行為（實測）
- **TWSE**：連續打 200+ 次後開始回 **307 Temporary Redirect**，且是靜默的（部分股票回 n=0 看起來像「沒資料」，其實是被擋）。對策＝每次 request 間隔 ≥0.7~1.5 秒、加 retry backoff、**成功月份數要印出來核對**（例如 12/12），不能只看有沒有拿到值。
- **Yahoo**：連打會回 **429 Too Many Requests**。對策＝間隔 2 秒 + 3~4 次 retry，或改用 `query2.finance.yahoo.com`。
- 🔴🔴 **115.08.13 實測：Yahoo 整段封死**——query1/query2 都 429，`WebClient` 不帶 User-Agent 幾乎必被擋；**加 browser UA（`Mozilla/5.0 ... Chrome/120.0 Safari/537.36`）後只搶得到頭 1~2 支**，之後照樣全擋（14 支只成功 2 支：^GSPC、^IXIC）。
- 🔴 **stooq 不是可靠備援**：`https://stooq.com/q/l/?s=^spx&f=sd2t2ohlcv&h&e=csv` 0813 實測 14 支**全部失敗**。
- → 這種日子的國際儀表板（費半/VIX/NVDA/MU/台積ADR/油金匯/台指期）**照實標「未取得」**，用 WebSearch 補到的片段要標明日期與來源，🔴不准拿舊快取當今天的數字（搜尋引擎常把 7 月舊聞混排成即時頭條）。
- 台股即時不受影響：`mis.twse.com.tw/stock/api/getStockInfo.jsp` 一直可用。🔴 漲停鎖死的股票 `z`/`pz` 會回 `-`，要改讀 `b`（委買五檔）第一檔或 `h`（當日最高）；`u`＝漲停價、`w`＝跌停價，比對 `h==u` 就知道是不是鎖死。

## 🔴 全市場 DD60（距 60 日高回檔）的划算算法
逐檔打 Yahoo 要 1,300+ 次必被限流。改成**抓 60 個交易日的 MI_INDEX 全市場面板**（只要 ~88 次 request、約 2 分鐘），一次得到全市場每檔的 60 日最高價 → DD60 全市場一次算完（實測 1,348 檔）。7/30 用這法跑出漏斗：1,373 → 流動性 551 → DD60≤−23.8% 331 → 營收 YoY>0 220 → 法人連3買 70。
同一份面板留最近 7 天的**最低價**，就能直接掃型②止穩訊號（單日跌≥5% + 5 日內首次當日低未破前日低）。

## 大盤均線／回檔
`https://query2.finance.yahoo.com/v8/finance/chart/%5ETWII?range=6mo&interval=1d` 自算 MA20 / MA60 / 60 日高。🔴距 60 日高有兩個口徑（盤中高 vs 收盤高），差約 0.8 個百分點，要標明用哪個。

相關 [[reference_full_market_screen]]、[[reference_excel_com_scan_pitfalls]]、[[feedback_evidence_required_no_assumptions]]。
