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

## 📱 手機/雲端同步（2026/06/09 說明）
- **無法從這台幫手機裝自動 hook**（settings.json 是各機各自的，雲端環境碰不到）。
- 折衷：在 repo 的 `CLAUDE.md` 寫進「開場先 pull、改完 push」紀律＋「一次只在一台改」警告 → 隨 repo 同步到手機，手機 Claude 讀 CLAUDE.md 會照做（靠指示、非硬性 hook）。
- 紀律：**一次只在一台改**，換台前先確認這台已 push、那台開場先 pull，避免雙邊改同檔衝突。

## 完成後的下一步（教使用者）
- 其他電腦：`git clone` 這個 repo。
- 手機/別台：瀏覽器開 **claude.ai/code** → 連這個 GitHub repo → 就能用 Code 強度並接上記憶。
- 眉角：自動記憶回想綁本機 `.claude\projects\<hash>\memory` 路徑，換機帳號名不同 hash 就不同；最乾淨是把這個 repo 當「每台都打開的工作目錄」，記憶跟著 repo 走。

關聯：[[feedback-no-clarifying-questions]]
