---
name: feedback-com-bulk-read-fake-fail-0803
description: 回測腳本逐格 COM 讀大檔會靜默回空字串造成假 FAIL——已改整欄一次抓＋加健全性自檢
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8630909a-8c12-49ce-905c-634babdaf80c
  modified: 2026-08-03T09:45:28.671Z
---

用 `$ws.Cells.Item($r,$c).Text` **逐格**讀計價本這種大檔，Excel COM 會讀到一半半死並**靜默回空字串**（不報錯），造成後段內容全部誤判成「找不到」。

115.08.03 `_規則同步回測.ps1` 報 FAIL 82，我沒當真——「141A 有 0 條 / 141E 有 0 條」＋結尾 RPC 失敗是典型徵兆。查證後檔案完好（141A 132 條、141E 133 條、15 個關鍵字全在），FAIL 100% 是假的。第二次跑 141E 被讀成 96 條（實際133），所以剛好是**最後面那批條文**全數假 FAIL。

**已修**：改成整欄一次抓 `$s.Range("A1:A$lastRow").Value2` 陣列，不逐格呼叫 COM；並加一道健全性自檢——讀到的字數 < 10,000 就直接中止並印「COM 讀取失敗，非內容缺漏，請關掉所有 Excel 後重跑」，不再吐一堆假 FAIL 讓人自己判斷。修完 PASS 116/FAIL 0，該自檢當天就實際攔截成功一次。

**Why:** 回測寫太鬆會讓我誤以為做完了（既有教訓）；但**回測會噴假 FAIL 一樣糟**——會讓人以為規則沒同步而白花時間，久了就不信回測。

**How to apply:** ①任何要掃大檔的腳本一律整欄／整塊 `Range().Value2` 讀，不逐格 ②回測腳本自己要先驗過再全跑 ③全 FAIL 或整批 0 筆先懷疑讀取失敗，不要直接認定內容缺漏 ④COM 掛掉的徵兆＝0x800706BE／0x800AC472／0x800A03EC／「有 0 條」，處理是殺掉無視窗 Excel、等 6~10 秒、重試。相關：[[feedback_backtest_discipline]]、[[reference_excel_com_scan_pitfalls]]、[[reference_powershell_variable_case_trap]]
