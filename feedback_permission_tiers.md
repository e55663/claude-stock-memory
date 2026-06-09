---
name: feedback-permission-tiers
description: 【2026/06/09 定案】三層權限自動化政策：安全操作自動放行、危險操作一律保留確認。使用者選「安全操作自動，危險保留」。釐清了「我問的確認題」vs「harness 權限彈窗」是兩回事
metadata:
  node_type: memory
  type: feedback
  originSessionId: current
---

**Why:** 使用者發現還是常被 yes/no 打斷，想要「交代的事直接做、太危險的才問」。關鍵釐清：他看到的 yes/no 大多**不是我在問**，是 **Claude Code harness 的權限關卡**（每次跑工具前攔）。記憶裡的「不要問確認題」只管得到「我主動問的確認」這層，管不到 harness 權限彈窗——那要靠 `settings.local.json` 的 allow 白名單放行。

**How to apply（三層）：**
- 🟢 **自動放行（已加進白名單，不問）**：唯讀 `Read`/`Glob`/`Grep`；改記憶檔 `Edit`/`Write`（**僅限記憶資料夾**）；固定同步腳本 `memory-sync.ps1`；WebSearch＋股票網站。
- 🟡 **我自己判斷直接做**：記憶庫範圍內的整理／改寫／落檔決定，做完告知。
- 🔴 **一律先問（永遠保留確認）**：刪除/覆蓋記憶庫**以外**的檔、`force push`/`reset --hard`/動 git 歷史、動 token/安全設定、裝/移除軟體、任何臨時 PowerShell、對外發送（寄信/貼文/丟外部服務）、真金白銀下單（本來就在券商做）。

**明確不做：** 不開 `bypassPermissions`（全自動）——等於拆掉安全網，使用者剛出過 token 外洩，更不該。正解是「白名單放行安全的、危險的繼續攔」。

**技術備註：** 記憶路徑 glob 在 Windows 下加了雙寫法（反斜線 `\\**` ＋ gitignore 式 `//C:/.../**`）防呆，哪個有效待實測；改設定後可能要開一次 `/hooks` 或重啟才重載。白名單在 `~/.claude/settings.local.json`。

關聯：[[feedback-no-clarifying-questions]]、[[feedback-auto-save-decisions]]、[[project-memory-sync-setup]]
