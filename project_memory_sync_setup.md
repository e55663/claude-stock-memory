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

## ✅ 自動同步（2026/06/09 加裝）
- 裝了 **Stop hook**（`~/.claude/settings.json`）：每次 Claude 回完話自動跑 `~/.claude/hooks/memory-autopush.ps1` → 對記憶 repo `git add -A`＋commit＋push，沒變更就安靜跳過、push 失敗不阻擋。
- 腳本訊息**刻意用純英文**：PowerShell 5.1 無 BOM 會用 Big5 誤讀中文導致解析失敗。
- 效果：使用者再也不用手動 push，這台電腦的記憶改動會自動上雲；手機/別台 pull 即同步。
- 與既有 UserPromptSubmit hook（stock-conflicts-reminder.ps1）並存，互不影響。

## 完成後的下一步（教使用者）
- 其他電腦：`git clone` 這個 repo。
- 手機/別台：瀏覽器開 **claude.ai/code** → 連這個 GitHub repo → 就能用 Code 強度並接上記憶。
- 眉角：自動記憶回想綁本機 `.claude\projects\<hash>\memory` 路徑，換機帳號名不同 hash 就不同；最乾淨是把這個 repo 當「每台都打開的工作目錄」，記憶跟著 repo 走。

關聯：[[feedback-no-clarifying-questions]]
