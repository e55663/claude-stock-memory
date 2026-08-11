# 🔴🔴🔴 正式Excel本禁止直接改內部XML

- 計價本、修改審查說明本、追蹤報表等正式Excel檔，禁止用ZIP／OpenXML直接改工作表XML或sharedStrings。
- 直接改儲存格若未同步calcChain等索引，會觸發「部分內容有問題」及修復警告。
- 只能用Excel正常開啟編輯，依「SaveAs暫存→WriteAllBytes覆寫原檔→刪暫存」存檔，並用Excel實際重開回測。
- Excel COM或背景程序逾時時，停止修改正式本，不得用內部XML繞過。
- 115.08.11事故：Codex錯用內部XML更新141A計價本B4，造成Excel移除calcChain。已備份並修復，工作表與共用文字部件雜湊不變。
