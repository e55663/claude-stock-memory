---
name: feedback_mac_vs_windows_stock-selection
description: Mac session 選股已能跑全市場海選(Python腳本)，與 Windows PowerShell 等價；資料源全部打通不需 token
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e7dbd013-1dea-4c3a-bd3b-2d42fbf08538
---

🔴🔴 **(2026/7/16 重大突破，已推翻本檔舊結論)** Mac session 原本只能用 WebFetch 主題驅動(由上到下、憑印象套框架、無量化佐證)。使用者質疑「憑什麼 Mac 不用 Windows 的海選法、有沒有兩年資料佐證」，逼出解法：**Mac 用 Python 腳本可做到跟 Windows PowerShell 等價的全市場海選**。

## 資料源全部打通(Mac 實測 OK，都不需 token)
- **TWSE STOCK_DAY_ALL**：🔴回傳 **CSV 非 JSON**(不能用 WebFetch 當 JSON 解)，用 `urllib` 抓 raw + `csv` 模組解，`utf-8-sig` 去 BOM；欄位:日期,代號,名稱,成交股數,成交金額,開,高,低,收,漲跌價差,筆數。漲跌%要自己算 spread/(close-spread)。→ 1,117 檔
- **TWSE T86 法人**：🔴關鍵參數 `?date=YYYYMMDD&selectType=ALL` 才回全市場(不帶=只回 7 筆水泥股，這就是舊 memo 誤以為「Mac T86 殘缺」的真因!)。欄位:代號,名稱,外資買,外資賣,外資淨(idx4),...投信淨(idx10),...自營淨(idx13)，股數÷1000=張。→ 13,579 筆
- **TWSE BWIBBU_ALL**：本益比/殖利率，WebFetch 或 urllib 皆可 → 1,079 檔
- **FinMind**：🔴**歷史兩年價量 + 個股法人皆免 token 直接抓**(`token=` 空字串即可)。TaiwanStockPrice / TaiwanStockInstitutionalInvestorsBuySell。可補「連N日買超」趨勢。但 FinMind **全市場單日法人 data_id 空=回 0 筆**，全市場要靠 TWSE T86，個股多日趨勢才用 FinMind。

## 腳本位置
`Downloads/CC agent/stock_scripts/full_market_scan.py`(本機) + 已 push 到 GitHub repo `e55663/claude-stock-memory/full_market_scan.py`(兩邊 pull 共用)。跑法:`python3 full_market_scan.py`。評分:動能≥3.5%+量/外資買超/投信買超/PE 5-40/殖利率≥3%，score≥3 進候選池。7/16 實測跑出 124 檔候選，抓到頂部推論找不到的昇陽半導體8028/台塑化6505漲停三大同買/京鼎3413(這就是底部海選的價值)。

## 現況與待辦
- ✅ 全市場海選、法人閘門 Mac 已可正式跑，不再「打折」
- 🔴 待補：①腳本目前只有今日單日法人，連3買趨勢要串 FinMind ②Windows`選股說明.txt`完整版(含7/15擴充五項自查)還沒進 GitHub，Mac 靠 memory 重建仍可能落差→建議把 txt 也 push ③選股對帳紀錄.txt 仍只在 Windows 桌面，Mac 這邊暫存進 [[project_stock_track_record]]
- Mac 環境:python3(3.9.6)/curl/jq 有，pwsh 無 → 所以用 Python 不用 PowerShell

**How to apply:** Mac 上「幫我選股」直接跑 full_market_scan.py 做全市場海選，不再用 WebFetch 湊個股。新聞催化劑仍用 WebSearch 補。輸出維持十區塊格式。[[reference_full_market_screen]][[feedback_stock_completeness_gate]]
