---
name: reference_webfetch_price_sign_flip
description: "WebFetch查即時股價時,頁面漲跌%符號偶爾會標反(現價明明跌卻標+),要用現價減昨收自己算方向,不能直接信頁面標籤"
metadata:
  node_type: memory
  type: reference
  originSessionId: current
---

🔴(2026/07/16發現)用WebFetch抓Yahoo股市個股頁面(`tw.stock.yahoo.com/quote/XXXX`)查即時股價時，頁面回傳的摘要偶爾會把漲跌方向標反——同一個回應裡「現價」「昨收」兩個數字明明相減是負的，但「漲跌幅」欄位卻顯示正號。這輪至少發生4次：光環(3234)、華城(1519)、中興電(1513)、聯詠(3034)都中招，且不是同一次查詢的規律性錯誤（有時對有時錯），像是頁面轉換HTML→文字摘要時的隨機抽取瑕疵，不是固定方向的bug。

**How to apply**：查完WebFetch的股價結果，不要直接照抄頁面標的「漲跌幅」正負號。一定要自己拿「現價」減「昨收」重新算一次方向，兩者不一致時以自己算的為準，並且要在講給使用者聽時附上「現價/昨收」兩個原始數字，讓使用者也能自行複驗，不能只丟一句「+X%」。這條連WebSearch回傳的舊聞摘要也可能有類似的日期/數字混講問題（見[[project_stock_framework_refactor]]「任何來源都可能不是即時，要看資料實際日期欄位」），WebFetch這條是更具體的「同一次查詢內部方向自相矛盾」現象，比單純「資料舊」更隱蔽、更容易看漏。
