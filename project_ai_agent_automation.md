---
name: project-ai-agent-automation
description: 把Claude打造成使用者AI agent的自動化建置（2026/06/11起）：雲端排程routine、權限紅線、已建/待建清單
metadata:
  node_type: memory
  type: project
  originSessionId: current
---

## 目標（2026/06/11 使用者拍板）
使用者要「把 Claude 打造成我的 AI agent」。定位 = **超強參謀+管家**:自動準備資訊/提醒/整理,但**最後動錢那一下留給使用者按**。
基礎已鋪好一半 = 跨裝置記憶庫([[project-memory-sync-setup]])就是 agent 的長期大腦。

## 🔴 權限紅線（沿用[[feedback-permission-tiers]],agent 也守）
**「動錢、下單、繳費、對外發送、改token」一律不開全自動、先讓使用者按確認。** Agent 只做「想好、備好、提醒」,不替他扣板機,尤其牽涉錢。

## 使用者選的三塊（可複選,從最高價值先建）
1. ✅ **每日盤前股市簡報** — 已建(見下)
2. ⏳ **每日瑣事/待辦管家** — 待建。方案:repo 放 todo.md,雲端每日讀+推提醒;**待使用者給「平常每天的瑣事清單」**。
3. ⏳ **記帳/帳務定期整理** — 待建。⚠️Excel在本機(Downloads\數字清單.xlsx)雲端碰不到→只能「每月固定一天提醒+開這台時我比對」;**待使用者給方便的日子(月初/發薪日)**。

## ❌ 已取消:每日盤前台股簡報(雲端 routine)
**2026/06/20 使用者決定取消**：沒有實際用到、感覺多餘。請手動到 claude.ai/code/routines 刪除 routine。用不用再看有沒有感覺到價值再說。

**✅(2026/06/26)已停用**：用 RemoteTrigger update `enabled:false` 把這個盤前簡報 routine 停掉（API 刪不掉但停用＝不再觸發、不再扣額度，效果等同）。確認 `enabled:false`。要徹底刪除仍須去 claude.ai/code/routines。

**🔴(2026/06/25)取消後仍照常觸發**：那天這個已標記取消的 routine 又自動跑了一次，代表 6/20 那次「請手動刪」沒有真的去 claude.ai/code/routines 點刪除（API 刪不掉，只能手動）。同次也確認**雲端網路白名單把 Yahoo 股市(`tw.stock.yahoo.com`)、Yahoo Finance JSON(`query1.finance.yahoo.com`)、TWSE OpenAPI(`openapi.twse.com.tw`) 三個全部 403 policy-deny**（用 `$HTTPS_PROXY/__agentproxy/status` 診斷確認，不是單一網站擋，是這個雲端環境的網路政策本身擋掉所有股市資料源）。WebSearch 能用但只給片段/落後一天以上的快取數字，不夠可靠拿來下單。**結論：這個 routine 在雲端環境下structurally 跑不出可靠盤面數據，不是暫時性問題；建議直接去刪掉、選股一律改本機 CLI 跑（見[[reference_full_market_screen]]既有結論）。**

原記錄備查：
- **routine ID:** `trig_01VvpscHwEzPRodfn7azHCg3`(管理頁 https://claude.ai/code/routines/trig_01VvpscHwEzPRodfn7azHCg3,刪除只能去 claude.ai/code/routines)
- **排程:** cron `0 0 * * 1-5` = 週一~五 台北08:00(=UTC 00:00);下次 2026/06/12 08:00。
- **環境:** env_016zgy9CveDNXym6RXLFbuBd(anthropic_cloud);**模型 claude-sonnet-4-6**;source repo=e55663/claude-stock-memory;tools=Bash/Read/Write/Edit/Glob/Grep/WebFetch/WebSearch。
- **內容:** clone 記憶repo→讀五區塊系統等→WebFetch Yahoo(加權/漲幅榜/族群/投信外資買超)+觀察名單→輸出大盤儀表板+五區塊菜單→最終訊息給使用者 + 寫 daily_briefing_latest.md 並 git push。
- **🔬 2026/06/11 已手動 run 一次測試(action=run)。待驗證三件:①雲端連不連得到 Yahoo(web存取)②有沒有照五區塊格式 ③repo 有沒有成功 push daily_briefing_latest.md。**
- **✅ 2026/06/16 驗證完成(使用者問「我都沒看到要怎麼看」):routine 正常每交易日08:00觸發(last_fired 6/16 00:02Z)、五區塊格式✅、push✅(daily_briefing_latest.md 已自動同步到本機 memory 夾)。❌唯一掛點=雲端 WebFetch 全被403封鎖→agent 改用 WebSearch 多源交叉比對,數字仍出但部分技術位/盤中量是「估」。📌待修方向:routine 改全走 WebSearch 或換可抓資料源,解掉403。**
- **📍交付/觀看方式(使用者本來不知道往哪看):最省事=每天在本機 Claude Code 問一句「今天簡報」,我直接讀同步下來的 daily_briefing_latest.md;備援=手機開 routine 管理頁看最新 run 最終訊息,或看 repo 該檔。🔴使用者偏好不是「每天人工問我看盤再手動下單」(那會重蹈要盯盤的覆轍)→簡報自動跑到本機、穩定桶靠階梯掛單自動接,人工判斷只留飆股桶。詳見[[feedback_brainless_order_system]]檢討(止穩人工判斷不得覆蓋穩定桶階梯掛單)。**

## ✅ 新用途:用雲端 routine 錨定 5 小時額度視窗（2026/06/26 建）
**目的不是回報內容,是卡住額度視窗起點。** 使用者上班 8:00–18:00,自然首用會把 5hr 視窗錨在 8:00→8-13/13-18/18-23,第三個 set 落在下班後(18+)被浪費,一天只用到 2 個 set。解法=用 6:00 觸發在他到公司前先把視窗錨在 6:00→6-11/11-16/16-21,三個 set 全落在上班時間內可用。
- 機制(我確定):訂閱額度=5小時滾動視窗,從該視窗第一次使用起算、滿5hr才重置,上面還有每週總上限;**不能提早重置**。6/11/16 兩兩剛好相隔5hr=三視窗無縫接力鋪滿6:00–21:00。
- 🔴**不確定、要使用者實測**:雲端 routine 觸發是否跟「互動使用」吃同一個視窗、能否錨定。建議第一天跑完去額度頁看重置時間有沒有變成16:00/21:00;有變=有效,沒變=雲端與互動不同桶=白扣要收掉。
- 五個 routine(2026/07/14 從三個加碼到五個,延續每5hr一個的節奏,涵蓋到深夜/晚間也在用電腦的情境;每天觸發含週末,Haiku,prompt 只回OK不准用工具→單次成本極低;但 API 把 allowed_tools 空清單吃掉自動帶回預設工具,靠 prompt 壓成本):
  - 額度視窗錨定 06:00 = `trig_01N6vgMEk1HayQUB5eTo3T7W` cron `0 22 * * *`
  - 額度視窗錨定 11:00 = `trig_01GKzSNYyQyapCtdeWa1nPJ5` cron `0 3 * * *`
  - 額度視窗錨定 16:00 = `trig_013muPWXX98pNxogjV54Lkev` cron `0 8 * * *`
  - 額度視窗錨定 21:00 = `trig_01E8ZFChRQkTL5MHWRbPXUFX` cron `0 13 * * *`(🆕2026/07/14)
  - 額度視窗錨定 02:00 = `trig_01HkjR4sQfTsQ7AUP7z6CzZw` cron `0 18 * * *`(🆕2026/07/14)

## ✅ 個人待辦推播系統(2026/07/14 建,見[[project_personal_todo_push_setup_0714]])
使用者反映下班意志力耗盡容易忘事,建了「repo待辦清單→晚間8:30雲端routine→PushNotification→手機推播」全鏈,已實測手機真的收得到。routine id `trig_014NDWaJJdrTgBCgZftAwzVi`,跟上面五個額度錨定routine是不同用途、獨立運作,別搞混。手機Remote Control配對用「Claude app→Code分頁→session列表點選」比QR code穩(QR code在桌面已登入瀏覽器情境下常常不會跳出來,要按空白鍵才顯示)。

## ✅ Claude Code 工具擴充（2026/07/09）
使用者說「要繼續開發claude的功能」,查+動手做了以下：

**Cowork（查證結果）**：不是聊天模式,是遠端獨立跑任務+關機續跑的工具,但**只有 Desktop app / claude.ai/code 網頁版才有,CLI(使用者現在用的)完全用不到**。對使用者現在「CLI即時讀寫本機Excel/PDF」這套本來就很順的工作方式非必要升級;痛點是「大批檔案背景跑」才有感。

**Gmail連接（查證結果）**：Desktop app 內建「Connectors」可連 Gmail/Calendar/Drive,OAuth點兩下,**但Gmail只能讀+草擬、不能自動送信**(Anthropic刻意設計)、附件內容讀不到。CLI這邊沒有官方Gmail MCP,只有社群版,設定複雜不建議。務實路徑=裝Desktop app用Connectors,CLI繼續做本機檔案工作。

**跨裝置記憶vs檔案（查證釐清）**：記憶(GitHub repo)三台真雙向自動同步(CLI+手機/雲端已驗證;Mac待設[[project-memory-sync-setup]]);但**本機檔案(桌面Excel/PDF)完全不同步,只存在這台Windows**——手機/Mac上我"認識"案件進度但摸不到那個檔案,只有這台能真的動手改。

**MCP工具安裝(使用者選"全部都裝",已完成/進行中)**：
- ✅ Node.js v22.14.0 + npm + npx：官方MSI裝不了(需admin權限,這個PowerShell非提權)→改免安裝zip版。🔴踩雷兩次：Copy-Item大量檔案會漏(761/2447個)，改用Move-Item(單一原子操作)才拿到完整2447個檔案；npm.cmd/npx.cmd這個zip本身沒附，手動補標準啟動器(`"%~dp0\node.exe" "%~dp0\node_modules\npm\bin\npm-cli.js" %*`)。裝在`%LOCALAPPDATA%\nodejs`，已加入使用者PATH。
- ✅ jq：官方winget來源又壞了(跟裝git那次[[project-memory-sync-setup]]同款故障)，改抓GitHub release的jq-windows-amd64.exe放`C:\Users\Seal_Lo\.local\bin\jq.exe`(已在PATH)。
- ✅ Playwright MCP：`claude mcp add playwright -- npx -y @playwright/mcp`已註冊；Chromium+FFmpeg+headless shell已下載完(`%LOCALAPPDATA%\ms-playwright`)。
- ⏳ Firecrawl：需使用者自己去firecrawl.dev註冊拿API Key(我不能幫他開外部帳號)，拿到後貼給我接`claude mcp add firecrawl -- npx -y firecrawl-mcp --api-key ...`。
- ⏳ Google Workspace CLI(gws)：⚠️已明確勸退但使用者選了要裝——文件裡就有真實案例(新帳號跑OAuth被Google判停權30天)，設定要使用者本人在瀏覽器操作GCP主控台(建專案/OAuth consent screen/加Test users)，我碰不到。開始前務必提醒用「平常有在用的舊Google帳號」、第一次`gws auth login`失敗別連續重試。
- ❌ skill-creator：使用者一度想用，已釐清用不到——貼過來的只是SKILL.md說明文字，缺實際執行的Python腳本(aggregate_benchmark/generate_review.py/package_skill.py等)，光文字裝不起來；且用途(打造給別人用的可重複Skill+eval框架)跟使用者情境(一對一處理請款單/選股)不合，已建議跳過。

**🔴狀態列(Status Line)已裝好但需重開才生效**：`~/.claude/statusline-command.sh`(bash腳本，雷蒙完整版規格：模型/Context進度條/5h+7d額度倒數/Git分支/增刪行數/專案名/最後訊息時間，emoji🚀✨)+`~/.claude/hooks/session-time.ps1`(UserPromptSubmit時寫時間戳到`~/.claude/last-session-msg`，系統預設時區)+`settings.json`新增`statusLine`key＋在既有UserPromptSubmit的hooks陣列**追加**第4個hook(沒動到原本completeness-gate/co-rule-gate/stock-gate三個)。**🔴Windows必須用Git Bash執行**(`"C:\...\Git\bin\bash.exe" "C:\...\statusline-command.sh"`)，用完整路徑不依賴PATH。腳本已用假JSON測過輸出正確(顏色碼+進度條+時間戳都對)。

**🔴關鍵教訓：PATH環境變數改了，已經在跑的Claude Code這個process看不到**——[Environment]::SetEnvironmentVariable(...,"User")只影響之後「新啟動」的process，這個對話視窗本身、還有它spawn出來的claude mcp健康檢查都還在用舊PATH(所以`claude mcp list`一度顯示playwright"Failed to connect"，不是真的壞，是環境沒刷新)。**使用者要重開Claude Code(`/exit`再`cc`或關窗重開)，狀態列跟Playwright MCP才會真的生效**，這是本次收尾时的唯一未完成驗證項，下次開場先確認這兩個有沒有正常顯示/連上。

## 機制重點（雲端 routine 限制,日後沿用）
- 雲端 isolated session,clone 指定 repo,跟本機無關、關機照跑。**碰不到本機檔案/環境變數**。
- cron 用 UTC,**最小間隔1小時**。台北時間-8=UTC。
- 不能用 API 刪 routine,只能 claude.ai/code/routines 手動刪。
- 輸出交付靠:①最終訊息(routines後台/通知看)②寫回 repo 檔案靠記憶同步到各裝置。
- 建 routine 工具 = RemoteTrigger(action: list/get/create/update/run);排程技能 = /schedule。
