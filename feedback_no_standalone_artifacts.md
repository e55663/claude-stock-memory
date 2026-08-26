---
name: feedback-no-standalone-artifacts
description: 不要自動產出本機獨立檔案(掃描txt/桌面HTML工具)；但0818起雲端 Artifact 看盤台是他要的、要繼續養
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae7d8384-da45-402c-8165-326541c3bb19
  modified: 2026-08-20T04:50:11.827Z
---

🔴🔴**(2026/08/18 大例外，本條規則從此只管「本機檔」)** 使用者當場要求把盤面分析做成網頁並說「越來越聰明的版本當然好」、「網頁的呈現方式目前有朝向我想要看的方向」。→ **claude.ai Artifact 看盤台是要繼續養的交付物，不是本條禁止的對象。** 網址固定 `https://claude.ai/code/artifact/06c9658a-9f94-4b94-bf87-78608b1b4efc`（重發布同一個 file path 就更新同一網址，別開新頁）。
- **他的看盤節奏＝四時段**：開盤(昨夜美股+夜盤) → 盤中(指數/台指期/族群) → 盤尾(15:00後三大法人籌碼) → 夜盤(台指期夜盤+美股)。頁面就照這四段排。他自評最有價值的是盤尾籌碼(自己查不到)。
- **能力已開**：`capabilities:{artifact:{},downloads:true}`。持倉表/待裁示/筆記做成 `artifact-sync` 區塊＝他自己填、存在頁面裡、我下次讀得回來；CSV 匯出用 downloads。
- 🔴 **做不到的別答應**：頁面被 CSP 擋外網，**不能自己去打 TWSE**；可用 capability 只有 artifact/downloads/mcp/self，他的連接器(Gmail/日曆/Drive/M365)沒有股市源。「自動更新」＝我排程重跑後重發布同一網址，不是頁面自己抓。
- 🔴 **踩過的雷**：在頁面腳本裡同步檢查 `window.claude` 就判定沒能力 → 它掛載比腳本晚，會把整頁鎖成唯讀（0818 他回報「想改持股都不能改」）。正解＝輪詢等它出現，且**永遠不因偵測不到就鎖欄位**，只據實顯示狀態。
- ⚠️ **仍未驗（唯一剩下的）**：重發布會不會蓋掉他在第 11 段 sync 區塊寫的持倉／筆記。0820 已實際重發布過一次（內容相同的 HTML），**要他重整頁面確認第 11 段東西還在**；他回報前不要當作已驗。
- **0818 收工時的狀態＝單一頁十段**（使用者要求「統一呈現在一個頁面，先不要很多分頁」）：01大盤儀表板／02對帳段／03主線六狀態／04AI族群兩桶／05兩桶決定／06模式C名單／07盤尾籌碼／08催化劑行事曆／**09選股規則全文**／10可編輯紀錄本；頂端 sticky 錨點導覽。舊頁 `ef4c82eb-0855-42ae-9493-8d2ea0e49e66`（今早那輪「115.08.18 台股判讀」）內容已全部併入，待他決定刪不刪。
- **資料新鮮度必分三種標明**：我這輪剛抓的即時／最後完整日K／別輪跑的未複驗（VIX、成交量百分位、模式C名單、SCFI 屬第三類）。口徑不同的數字兩個都列並標口徑（例：8/17 成交金額 一般股票 9,071 億 vs 含權證 9,811 億），不准挑好看的講。
🔴🔴🔴 **(2026/08/20 裁示定案＋全部實測完畢) 更新頻率＝跟額度視窗一起跑，三時段：台北 06:00 / 11:10 / 16:20**（他原話「要跟我跑額度的來源時間一起跑」「就是6點 11點 16點那個」，**21:30 不含**）。
- 🔴 **架構＝兩段式，因為沒有任何一邊同時具備「抓得到股市資料」與「發得了 Artifact」**：
  - **stage1 本機**（Windows 工作排程 `看盤台更新-盤前/盤中/盤尾`，週一~五 **05:30 / 10:40 / 16:00**）→ 跑 `C:\Users\Seal_Lo\Downloads\agent\dashboard_update.ps1 -Slot PreOpen|Intraday|Close`，它把 `dashboard_prompt.md`（{SLOT} 代換）餵給 `claude.exe -p --model claude-sonnet-5 --permission-mode bypassPermissions`；本機網路通，實抓 TWSE → 改 `memory\artifact\stock_dashboard.html` → 寫回選股對帳紀錄 → git push。log 在 `agent\logs\dashboard\`（留最新 60 支）。
  - **stage2 雲端**＝**直接改寫他既有的三支「額度視窗錨定」routine**（`trig_01N6vg…`06:00／`trig_01GKzS…`11:10／`trig_013muP…`16:20），不另開 routine＝**零額外雲端成本**，錨定功能照舊。它 clone repo → 讀 `artifact/stock_dashboard.html` → 發布回固定網址。model 用 haiku-4-5。
  - 兩段差 20~30 分鐘讓本機先跑完；雲端有兩道閘：**週末（`date -u +%u` 為 6/7）不發布**、**HTML 最後 commit 距今 >6 小時就不發布**（＝他電腦沒開，寧可不發也不發舊的）。
- 🔴🔴 **0820 實測結論（別再重測）**：①**雲端沙箱 egress 封鎖所有股市網域** —— openapi.twse.com.tw、www.twse.com.tw（MI_INDEX 與 T86）、tw.stock.yahoo.com、query1.finance.yahoo.com、stooq.com、www.cnyes.com 全部 `EGRESS_BLOCKED`；雲端只有 **WebSearch** 與 **claude.ai artifact** 通得了 → **雲端絕對不能自己跑選股**，硬跑＝拿搜尋摘要當收盤價＝掰數字。②**headless `claude -p` 沒有 Artifact 工具**（ToolSearch 查無）→ 本機排程發不了網頁。③**雲端 session 有 Artifact 工具、也 clone 得到 repo**。
- 🔴🔴 **本機 stage1 目前是壞的（0820 兩次都失敗，未修好）**：`claude.exe -p` 在 Windows 工作排程底下跑不起來，`LastTaskResult 3221225786`（0xC000013A ＝ STATUS_CONTROL_C_EXIT），log 只留 start 一行。**管線餵 stdin 和把 prompt 當引數傳，兩種寫法都死**。未排除的方向：沒有 console／改用 `cmd.exe /c … > log 2>&1` 包一層／勾「以最高權限執行」／`--output-format`。🔴 **`LastTaskResult 267009` 只代表「執行中」，不是成功** —— 0820 我就是看到 267009 就對他宣告「起得來了」，結果還是失敗，當場更正。**要看到 log 有內容、HTML 有改、push 成功，才算成功。**
- ⚠️ **排程與電池**：用預設 settings 建的排程在電池模式會卡 **Queued** 不執行。看盤台三支已設 `-AllowStartIfOnBatteries -DontStopIfGoingOnBatteries`，會啟動；**啟動後死掉是另一回事，別混為一談**。
- 🔴 **發布的三個坑（照做，別自己發明）**：①**發布前一定要先 WebFetch 一次該 artifact 網址**，否則報 `This session hasn't viewed the latest version of the artifact`；②**不要傳 `capabilities`、不要傳 `contract`** —— 伺服器自動沿用 `{artifact, downloads}` / `0.2.4`，傳了反而會覆蓋掉；③**favicon 固定 📈**、url 一字不差、`file_path` 用 repo 裡那支。
- **正本 HTML ＝ repo 的 `artifact/stock_dashboard.html`**（0820 從已發布頁抓回、剝掉 frame-runtime 外殼後入庫，963 行）。**不要再依賴 session scratchpad 的 stock-0818.html**。改頁面＝原地 Edit 這支檔，不重建。
- ⚠️ **兩支一次性測試 routine 已停用**（`trig_01Xs1Zah2gtsnFAXZoUPbyGP` 等），留著當紀錄，別重新啟用。
- 🔴 **省力關鍵在「更新方式」不在頻率**：不重建整頁。**WebFetch 這個 artifact 網址可以把整份 HTML 拉回來**（0818 實測 81.9KB，會落成本機檔給我讀）→ 只 Edit 變動的數字段 → 發布回**同一個 file path** → 網址不變、他只留一個書籤。原始 HTML 只存在某輪的 session scratchpad（`stock-0818.html`），**不要依賴那個路徑**，一律用 WebFetch 取回當正本。
- 🔴 **兩件未驗，沒驗不准開排程**：①雲端 routine 的 allowed_tools 裡沒有 Artifact，能不能重發布這頁**未證實** → 要開就先跑一支一次性測試 routine，失敗就退回「他打一句、我在本機跑」；②重發布會不會蓋掉他在第 10 段 artifact-sync 區塊寫的持倉／筆記 → 測法＝請他在「盤中筆記」打一行字，我重發布，他重整看還在不在。
- **「每日盤前台股簡報」routine（`trig_01VvpscHwEzPRodfn7azHCg3`）自 2026/06/26 起 `enabled:false`，等於早就沒在跑**。功能與看盤台重疊，傾向直接改寫成「更新看盤台」，不要兩套並存。
- **頁面操作方式（他問過，答案固定）**：右上角標籤變綠「可編輯，會存下來」才開始打字，灰色「未連上儲存」就先重整；01–09 段是我更新的，他改了會被下次重發布蓋掉；**第 10 段才是他的**（持倉直接點格子改／「＋新增一列」／「刪除」；待辦打勾＝完成；盤中筆記直接打；全部自動存不用按存檔）；最下方有「匯出 AI 族群兩桶 CSV」。
- **待改**：模式C 名單表與持倉表 `min-width:680px`，手機要橫向捲 —— 違反 [[user-profile]]「表格不要橫向捲動」，下次重發布時改成手機一檔一卡片。
- 純文字仍是預設：要貼去 LINE/Word 的東西(memo、呈核字、請款文字)一律純文字，絕不出網頁。分工見本檔末。

選股/看盤時**不要自動把結果另存成本機獨立檔案**（如桌面的 `股票掃描結果.txt`、`選股策略系統.html` 這類掃描輸出或網頁儀表板工具）。2026/06/10 使用者把這兩個檔都叫我刪掉，明確說「我都直接跟你談 所以不用這些」。

**Why:** 使用者的用法是直接對話，不開離線工具。獨立檔案＝(1)跟記憶/對話資訊重複 (2)是靜態快照、做完當天就過期(html 還停在 5/27 數字) (3)他還要記得去開→反而是負擔。

🔴**(2026/06/17)`桌面\股票掃描結果.txt` 又出現＝不是我選股產生的,是 Windows 排程「台股訊號掃描」每日跑 `C:\Users\Seal_Lo\Documents\股票腳本\股票訊號掃描.ps1` 吐的。使用者說「不要再產生」→ 我已 `Disable-ScheduledTask 台股訊號掃描`(可逆,腳本沒刪)。** 若日後又冒出來,先查這個排程是否被重新啟用。

**How to apply:** 選股結果直接在對話講完即可，不主動生成 txt/html/儀表板檔。**唯一例外**：使用者的個人記帳 Excel `數字清單`（那是他長期在用的資料檔，不是我硬塞的工具）→ 見 [[project-budget-spreadsheet]]。要做檔案前先問，不要預設產出。關聯 [[feedback-brainless-order-system]]。

## 🔴 排程失效病灶（115.08.26 實查，未解）
- 三個排程（看盤台更新-盤前/盤中/盤尾）自 **8/24 16:00 起連 6 次**全部 exit 3221225786 ＝  xC000013A（STATUS_CONTROL_C_EXIT），log 只有開頭那行、**沒有 end 行**＝連 powershell 宿主一起被砍。頁面正本因此停在 8/24 10:56。
- dashboard_update.ps1 註解早就寫過同一個錯誤碼（原因是把 prompt 用 pipe 餵進 claude.exe），現在已改成當參數傳，**所以不是同一個病因**。claude.exe 8/26 10:28 自動更新過，但失敗從 8/24 就開始＝不是更新造成的。
- 12:50 手動 schtasks /Run "看盤台更新-盤中" → **跑成功**（exit 0，12:50:27~12:58:19，push bab1530）。⇒ 腳本本身沒壞，是環境/時機性。🔴 **根因未確認**，下一個觀察點＝16:20 盤尾那輪。
- 排查用指令：Get-ScheduledTask 看盤台更新-* | Get-ScheduledTaskInfo（看 LastTaskResult）＋ Downloads\agent\logs\dashboard\*.log（只有 44~47 bytes＝秒退）。

## 兩段式的時間差（他問「網址有沒有更新」時要先講的）
- 本機推 repo ≠ 網址更新。雲端 routine 只在 **06:00／11:10／16:20** 讀 repo 發布。12:57 才 push 的內容，要等 16:20 才會自己上線。
- 🔴 我在 Claude Code 這邊**可以直接發布**（帶 url 參數更新同一網址），115.08.26 13:05 實測成功；capabilities {artifact, downloads} 與 contract 0.2.4 會自動沿用，不要自己傳。
- 發布前會被要求「先看過線上版」：**WebFetch 該網址 → 把它存下來的整份 HTML 用 Read 逐行讀完** 才准發布，只 WebFetch 不夠。
- 「重發布會不會蓋掉第 11 段筆記」：115.08.26 比對過線上版與本機版的第 11 段（持倉 300@607.19、5 條待辦、盤中筆記空白）**完全一致＝他當時沒寫東西**，所以這次發布沒有東西可蓋。**這題仍未真正驗證**，等他實際寫過筆記之後再測一次。

## 🔴🔴 看盤台頁面結構定版（115.08.26，他說「網址這個超亂欸 整理一下吧」之後）
**病灶＝舊快照掛著紅字警語繼續佔版面，看起來像現在的盤。**
- **新規矩（往後每輪都照這條）：這一頁只放「本輪實算」的東西。沒重跑的段落不再用舊數字佔位，改成在「08 本輪沒跑的」那一段列名。**
- 頁首那面文字牆改成 **「資料新鮮度」四格表**：①本輪實抓 ②最後完整日K ③官方尚未發布(MI_INDEX 14:30／T86 16:00) ④隔夜美股。**頁面每個數字都要對得回其中一格。**
- 定版結構 01~10：01大盤儀表板／02對帳段／03主線六狀態／04兩桶決定／05模式C名單／06國巨／07催化劑／08本輪沒跑的／09選股規則全文(不動)／10我的紀錄本(不動)
- 0826 移除的四段（**內容沒消失，在 git 歷史與選股對帳紀錄.txt**）：舊「主線六狀態(8/20)」「AI族群兩桶(8/20)」「分批候選12檔(8/19)」「盤尾籌碼(8/18)」
- 🔴 **刪區塊要連 script 一起檢查**：CSV 匯出鈕原本 `querySelectorAll('#ai .panel')`，#ai 段被刪後會匯出空檔，已改指 `#modec table tbody`。**改版後跑一次「script 裡每個 getElementById/querySelector 在頁面找不找得到」。**
- 排版健檢招式：div/section/table 開閉標籤數要相等、nav 的每個 `href="#id"` 都要有對應 `<section id>`。
