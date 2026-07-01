---
name: project-memory-sync-setup
description: 跨裝置記憶同步：把記憶資料夾做成私人 GitHub repo(e55663/claude-stock-memory)，讓其他電腦/手機(claude.ai/code)接上記憶。✅2026/06/09 已完成 push＋認證快取，雲端同步已通。下一步是在其他裝置 clone/連 repo
metadata:
  node_type: memory
  type: project
  originSessionId: current
---

## 為什麼做這件事
使用者的 Claude Code 記憶只存在這台電腦的本機檔案，換電腦/手機就沒了。決定走「方案A」：把記憶資料夾做成**私人 GitHub repo**，之後在其他裝置用 **claude.ai/code（網頁版 Code，手機也能開）** 連這個 repo 接上記憶。使用者覺得 Code 比手機 App 強，這是手機上用 Code 強度的正解。

## ✅ 已完成（2026/06/08）
- 裝好 git（**使用者模式**，路徑 `C:\Users\Seal_Lo\AppData\Local\Programs\Git\cmd\git.exe`；不在 PATH 時要用完整路徑）。版本 2.54.0。winget 來源毀損裝不了，改用 GitHub 官方安裝檔直裝。
- 記憶資料夾 `C:\Users\Seal_Lo\.claude\projects\C--Users-Seal-Lo\memory` 已 `git init`（**刻意 init 在原地**，保留本機自動記憶回想功能）。
- 分支 `main`，第一個 commit `74b1e77`（10 個 .md 全納管）。
- 已設 `user.name=Seal Lo`、`user.email=e55663@gmail.com`、`core.autocrlf=true`、全域 `credential.helper=manager`。
- 已加 remote：`origin = https://github.com/e55663/claude-stock-memory.git`（GitHub 上 repo 已建，私人，空的）。

## ✅ 已完成（2026/06/09）push 與認證
- 用 Fine-grained PAT（Contents=R/W、Metadata=R 自動帶、90天到期、到期前約1週GitHub會寄信到 e55663@gmail.com 提醒）完成首次 push：`& $git -C $repo push https://e55663:<TOKEN>@github.com/...git main:main`。
- 認證已被 **Windows 認證管理員快取**：之後 push/pull 不用再貼 token；實測 `GIT_TERMINAL_PROMPT=0` 下 `ls-remote origin` 仍可讀＝免互動可用。
- remote URL **乾淨無 token 明文**（token 只用在那一次性 push URL，沒寫進 .git/config）。
- upstream 已設：`main` 追蹤 `origin/main`。
- 眉角：`git credential approve` 用 PowerShell 多行 stdin 一直報 missing field，但其實 push 當下 GCM 已自動存好認證，不必硬塞。git 不在 PATH，要用完整路徑 `C:\Users\Seal_Lo\AppData\Local\Programs\Git\cmd\git.exe`。
- token 可隨時在 https://github.com/settings/tokens?type=beta Revoke。

## ✅ 自動同步（2026/06/09 加裝＋強化）
- **Stop hook**（自動 push）：每次回完話跑 `~/.claude/hooks/memory-autopush.ps1` → `git add -A`＋commit＋push，沒變更安靜跳過。**已強化**：push 被拒（別台先推）時自動 `pull --rebase --autostash` 後重推一次，避免衝突卡死。
- **SessionStart hook**（自動 pull，2026/06/09 新增）：每次這台開 Claude 自動跑 `~/.claude/hooks/memory-autopull.ps1` → `git pull --rebase --autostash`，**解決「換台這台不會自動更新」**。實測成功。
- 腳本訊息**刻意用純英文**：PowerShell 5.1 無 BOM 會用 Big5 誤讀中文導致解析失敗。
- 效果：這台＝開場自動拉最新、回完話自動推；**真正的雙向自動同步**。
- 與既有 UserPromptSubmit hook（stock-conflicts-reminder.ps1）並存，互不影響。

## 🔐 資安清理（2026/06/09）
- **問題**：PAT token 曾以**明文**散在 `settings.local.json` 的多條 allow 權限裡（且曾在對話中被印出 → 已外洩進 session 紀錄）。
- **已清**：刪掉 settings.local.json 所有含 token 的 git 指令權限；確認 hook 腳本、settings.json、remote URL 全部**無 token 明文**。token 現在只存在 Windows 認證管理員（加密、正解）。
- **⚠️ 強烈建議使用者做（我做不到，需 GitHub 登入）**：因 token 已外洩進對話紀錄，去 https://github.com/settings/tokens?type=beta **Revoke 舊 token、重新產一個**。重產後舊的認證快取會失效，下次 push 會失敗 → 需更新 Windows 認證管理員那筆 `git:https://github.com`（或重跑一次帶新 token 的 push 讓 GCM 重存）。

## ✅ 重新授權＋寫入同步修復（2026/06/18）
- 使用者前一晚(6/17)在 **Mac 重新 regenerate 憑證**（即 6/09 一直待辦的「Revoke 舊 token 重產」終於做了）→ 這台 Windows 的舊寫入憑證失效。
- 隔天開 Windows，背景同步想 push 失敗 → **Git Credential Manager(GCM) 自動彈出 GitHub 登入視窗**，並產生 `http://127.0.0.1:<port>/...oauth/authorize?...code_challenge...scope=repo+gist+workflow` 這類連結。
- 🔴 **判讀這種連結的口訣**：那是 GCM 的「本機 OAuth 重新登入」彈窗，不是外部威脅。`redirect_uri=127.0.0.1:<port>` 代表只能在本機完成。**若是過期殘留**（用 `Get-NetTCPConnection -LocalPort <port>` 查無程式在聽 = 門已關）→ 忽略即可、按了也接不起來；**若是當下剛觸發的活視窗** → 登入 `e55663`→Authorize 完成它。
- 6/18 實測：`fetch`(讀) 早就通(exit 0)，但 `push`(寫) 觸發 GCM 彈窗 → 使用者在活視窗完成授權 → push 成功 `c3ab0db..f086707 main->main`、狀態回 `main...origin/main`。**寫入同步已修復**。GCM 已把新認證存進 Windows 認證管理員，之後免再登入。
- 認證方式已從 6/09 的明文 PAT 改為 **GCM OAuth**（更安全，無 token 明文）。

## 📱 手機/雲端同步（2026/06/09 初版說明，已被下方 2026/06/19 修正取代）
- ~~無法從這台幫手機裝自動 hook（settings.json 是各機各自的，雲端環境碰不到）~~ ← **這個判斷錯了，見下方修正**。
- 舊折衷：在 repo 的 `CLAUDE.md` 寫進「開場先 pull、改完 push」紀律，靠 Claude 讀指示照做（非硬性 hook）。

## ✅ 手機/雲端真自動雙向同步（2026/06/19 修正＋補完）
- **發現**：`~/.claude/settings.json` 才是「各機各自、雲端碰不到」；但 **repo 內的 `.claude/settings.json`（專案層級設定）會跟著 git 一起同步到每台裝置**，包括手機/雲端的 claude.ai/code（雲端每次開新 session 就是重新 clone 這個 repo，專案層級設定也會被讀到）。
- **已有**(更早就建好,2026/06/17)：`.claude/settings.json` 的 `SessionStart` hook → 跑 `.claude/hooks/session-start.sh`：用環境變數 `CLAUDE_CODE_REMOTE=true` 判斷「這是雲端/手機環境」才動作，自動 `git fetch origin main` + merge，等於手機/雲端開場自動pull。
- **新增**(2026/06/19)：補上對應的 `Stop` hook → 跑 `.claude/hooks/stop-sync.sh`：同樣只在 `CLAUDE_CODE_REMOTE=true` 時動作，`git add -A`→有變更才commit→`push origin HEAD:main`（推不上去就fetch+merge再重推，最多試3次）。
- **效果**：手機/雲端的 claude.ai/code 現在跟 Windows 那台一樣是**真正雙向自動同步**：開場自動pull、結束自動push到main，不用再靠人/Claude手動記得pull/push。
- 跟 Windows 那台的 user-level hook（`~/.claude/hooks/memory-autopush.ps1` 等）是兩套獨立機制，互不衝突：Windows 那套本來就只在本機跑；這套是專案層級、隨repo走、只在雲端環境(`CLAUDE_CODE_REMOTE=true`)觸發。
- 殘留的舊紀律（CLAUDE.md「一次只在一台改」）現在比較像保險，不再是唯一防線——但雙邊**同時**改同一份檔案還是可能衝突，建議還是盡量不要兩台同時改。

## 完成後的下一步（教使用者）
- 其他電腦：`git clone` 這個 repo。
- 手機/別台：瀏覽器開 **claude.ai/code** → 連這個 GitHub repo → 就能用 Code 強度並接上記憶。
- 眉角：自動記憶回想綁本機 `.claude\projects\<hash>\memory` 路徑，換機帳號名不同 hash 就不同；最乾淨是把這個 repo 當「每台都打開的工作目錄」，記憶跟著 repo 走。

## ✅ 搬到 Downloads\agent ＋ 合併個人記憶（2026/06/18）
- **起因**：使用者要把工作目錄從家目錄 `C:\Users\Seal_Lo` 改成 `C:\Users\Seal_Lo\Downloads\agent`（東西集中、不散在家目錄）。
- **發現**：之前從 Downloads\agent 開過 Claude → 生出第二個專案 `C--Users-Seal-Lo-Downloads-agent`，內有**另一套純本機、無雲端備份的「個人生活記憶」9 條**（語言/基本資料/興趣/健身/花費/人際/事件/互動偏好）。從 Downloads\agent 開 Claude 只讀得到這 9 條、讀不到工作那 43 條。
- **使用者決定**：合成一套、都上雲端。
- **已做**：①個人 8 條 .md 併進工作 git repo、MEMORY.md 索引合併（含一條 [[feedback_copy_friendly_plaintext]] vs feedback_preferences「表格 vs 純文字」衝突提醒）②整個 git repo 從 `…\C--Users-Seal-Lo\memory` **搬到** `…\C--Users-Seal-Lo-Downloads-agent\memory`（51 個 .md，.git 完整）③兩個 hook 的 `$repo` 路徑都改指向新位置 ④`CLAUDE.md` 複製進 `Downloads\agent\` ⑤push 上雲端 `211b1a9..f354b08`（個人記憶從此有備份）⑥刪掉自建備份。
- 🔴 **使用者以後一律從 `C:\Users\Seal_Lo\Downloads\agent` 開 Claude**（不要再從家目錄開，家目錄那個專案的 memory 已搬空）。
- 路徑變更後新位置：`C:\Users\Seal_Lo\.claude\projects\C--Users-Seal-Lo-Downloads-agent\memory`（git remote、雲端 repo 名稱不變，仍是 e55663/claude-stock-memory）。
- **使用者啟動方式＝終端機打 `cc`**。`cc` 有兩條定義都已統一切到 Downloads\agent：①PowerShell profile 函式 `CC`（`Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`）原本就 `Set-Location Downloads\agent; claude` ②`C:\Users\Seal_Lo\.local\bin\CC.cmd` 2026/06/18 改成 `cd /d Downloads\agent` 後再 `claude %*`（原本只 `claude %*` 會在當下資料夾開→曾誤開家目錄載到錯記憶）。所以使用者習慣不用改、照打 `cc` 就一定開到 Downloads\agent。

## 🟠 Mac 本機自動同步待設定（2026/06/29）
- 使用者要三台（手機/Windows/Mac）都自動同步；明確說**手機止血不算解決、要的是 Mac 也能用**，且問「回家打開 Mac 要按啥」。
- 🔴 **核心觀念已跟使用者講通且他接受**：三台不是互連，都跟 GitHub 雲端 repo 對接，**不需要兩台同時開機**（公司 Windows / 家裡 Mac 各自跟雲端同步即可）。唯一紀律＝來源那台要成功 push，下一台才拿得到。
- **Mac 現況推斷**：6/17 使用者曾在 Mac regenerate PAT＝Mac 至少有 git＋對 repo 的認證，repo 可能已 clone。**但缺本機自動 hook**：repo 內 `.claude/settings.json` 的 `.sh` hook 第一行 gate `CLAUDE_CODE_REMOTE=true`（只在雲端/手機跑），**Mac 本機 CLI 不是 remote → 會 exit 0 跳過 → 不會自動 pull/push**。所以 Mac 本機要比照 Windows 另設一套 user-level hook（`~/.claude/settings.json` SessionStart pull + Stop push，呼叫 mac 版 .sh，不 gate remote）。
- 🔴 **要在 Mac 現場做、不能從 Windows 這台代設**（碰不到 Mac 檔案）。前提：先確認 Mac 有裝 Claude Code CLI。
- **下一步**：使用者回家打開 Mac 的 Claude Code → 說「設定 Mac 記憶同步」→ 現場接 hook＋git＋路徑。設好後＝跟 Windows 一樣，開來用就自動同步、零按鈕。
- 若 Mac 是用 claude.ai/code 網頁版（非本機 CLI）＝走 remote 路徑、跟手機同套 .sh，那要解的是 git 認證而非 hook。

關聯：[[feedback-no-clarifying-questions]]
