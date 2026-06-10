---
name: feedback-no-standalone-artifacts
description: 不要自動產出獨立檔案(掃描txt/網頁儀表板/HTML工具)；使用者直接跟我對話，這些檔案是多餘負擔
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae7d8384-da45-402c-8165-326541c3bb19
---

選股/看盤時**不要自動把結果另存成獨立檔案**（如桌面的 `股票掃描結果.txt`、`選股策略系統.html` 這類掃描輸出或網頁儀表板工具）。2026/06/10 使用者把這兩個檔都叫我刪掉，明確說「我都直接跟你談 所以不用這些」。

**Why:** 使用者的用法是直接對話，不開離線工具。獨立檔案＝(1)跟記憶/對話資訊重複 (2)是靜態快照、做完當天就過期(html 還停在 5/27 數字) (3)他還要記得去開→反而是負擔。

**How to apply:** 選股結果直接在對話講完即可，不主動生成 txt/html/儀表板檔。**唯一例外**：使用者的個人記帳 Excel `數字清單`（那是他長期在用的資料檔，不是我硬塞的工具）→ 見 [[project-budget-spreadsheet]]。要做檔案前先問，不要預設產出。關聯 [[feedback-brainless-order-system]]。
