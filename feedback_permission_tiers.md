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

**🔴(2026/06/26 使用者覆寫此條)已改開 `bypassPermissions`（全自動）**：使用者拿雷蒙「安全三件套」macOS文件來裝、二次確認後仍選 bypass。已寫進 `~/.claude/settings.json`：`permissions.defaultMode=bypassPermissions` + `skipDangerousModePermissionPrompt=true` + 22條 deny 黑名單(毀滅級:Format-Volume/Clear-Disk/Remove-Partition/Clear-RecycleBin/Stop-Computer/Restart-Computer/shutdown/diskpart/format/cipher /w,PowerShell與Bash雙寫;不含一般Remove-Item/Move-Item以免擋到Excel/備份/歸檔)。⚠️**先前『不開bypass』的原因之一=6/09架記憶同步時曾token外洩**,但🔴**已remediated**(6/17撤銷舊PAT換GCM OAuth、無明文token;6/26重掃settings/hooks/git config全乾淨)→那把外洩金鑰已作廢、非現在進行式漏洞,別再當成開放中的風險嚇使用者(6/26使用者問「token外洩我怎不知道」=他沒當成事件,我引用記憶沒講清楚害他緊張)。詳見[[project_memory_sync_setup]]。bypass的真實風險改看「Windows護欄薄」那點。
🔴**Windows安全網薄弱真相(老實講)**：deny規則是「前綴比對」(`Bash(git *)`式),抓不到包裝過/順序變化的指令;而且我幾乎都用 `& powershell.exe -File x.ps1` 跑腳本→deny/hook只看得到那行命令字串、看不到.ps1檔內容→腳本內的危險指令繞過所有自動護欄。所以bypass下真正的保護=①我自己的紀律(改檔前先備份/驗證/只刪自建備份/搬檔前驗路徑)②OS層(資源回收桶/OneDrive/File History要開著才救得回)③隨時可改回模式。垃圾桶層(trash/brew/zsh)是macOS的,Windows裝不起來(我跑-NoProfile)。
**舊版(已不適用,留參考):** 不開 `bypassPermissions`（全自動）——等於拆掉安全網，使用者剛出過 token 外洩，更不該。正解是「白名單放行安全的、危險的繼續攔」。

**技術備註：** 記憶路徑 glob 在 Windows 下加了雙寫法（反斜線 `\\**` ＋ gitignore 式 `//C:/.../**`）防呆，哪個有效待實測；改設定後可能要開一次 `/hooks` 或重啟才重載。白名單在 `~/.claude/settings.local.json`。

關聯：[[feedback-no-clarifying-questions]]、[[feedback-auto-save-decisions]]、[[project-memory-sync-setup]]
