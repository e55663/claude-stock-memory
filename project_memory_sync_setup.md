---
name: project-memory-sync-setup
description: 跨裝置記憶同步進度（2026/06/08 起）：把記憶資料夾做成 GitHub repo，讓其他電腦/手機(claude.ai/code)也能接上記憶。git/init/commit/remote 都好了，只差最後 push 認證——明天用 PAT 完成
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

## ⏳ 還沒做：最後一步 push（明天做）
push 一直失敗（exit 128）。**根因**：Claude Code 的工具/`!` 都是非互動環境，GCM 的瀏覽器登入視窗彈不出來。**不要再試彈窗認證**。

**改用 Fine-grained PAT（已跟使用者講好，明天他來用）：**
1. 使用者到 https://github.com/settings/tokens?type=beta 產生 token：
   - Repository access → Only select repositories → `claude-stock-memory`
   - Permissions → Repository permissions → **Contents = Read and write**
2. 使用者把 `github_pat_...` 貼給我。
3. 我用 token 完成 push，例如：
   `& $git -C $repo push https://e55663:<TOKEN>@github.com/e55663/claude-stock-memory.git main:main`
   推完把 token 存進認證管理員、把 remote URL 還原乾淨（不要把 token 留在 .git/config 明文）、`git branch --set-upstream-to=origin/main main`。
4. 提醒使用者 token 可隨時在同頁 Revoke。

## 完成後的下一步（教使用者）
- 其他電腦：`git clone` 這個 repo。
- 手機/別台：瀏覽器開 **claude.ai/code** → 連這個 GitHub repo → 就能用 Code 強度並接上記憶。
- 眉角：自動記憶回想綁本機 `.claude\projects\<hash>\memory` 路徑，換機帳號名不同 hash 就不同；最乾淨是把這個 repo 當「每台都打開的工作目錄」，記憶跟著 repo 走。

關聯：[[feedback-no-clarifying-questions]]
