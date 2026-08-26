---
name: project_cross_device_setup
description: 跨裝置同步手冊(整合4檔):記憶repo與hook機制/三台對接雲端不需同時開/Windows與Mac設定差異與待補/Mac硬體與VM待辦
metadata: 
  node_type: memory
  type: project
  originSessionId: 365bbf1a-11d3-4cf1-8927-79cb45fcc87f
  modified: 2026-08-06T03:13:21.040Z
---

# 跨裝置同步（Windows／Mac／手機雲端）

## 現行架構
- 單一真相＝私人 GitHub repo **`e55663/claude-stock-memory`**。三台都跟雲端對接，**不需要兩台同時開機**；唯一紀律＝來源那台要成功 push，下一台才拿得到。
- 記憶實際位置：`C:\Users\Seal_Lo\.claude\projects\C--Users-Seal-Lo-Downloads-agent\memory`（git init 在原地，保留本機記憶回想）。
- 🔴 **使用者一律從 `C:\Users\Seal_Lo\Downloads\agent` 開 Claude**（終端機打 `cc`；`Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` 的 `CC` 函式與 `.local\bin\CC.cmd` 都已固定 cd 到這裡）。從家目錄開會載到已搬空的舊專案。
- git.exe **不在 PATH**：要用完整路徑 `C:\Users\Seal_Lo\AppData\Local\Programs\Git\cmd\git.exe`。
- 認證＝**GCM OAuth**（無 token 明文），存在 Windows 認證管理員。若出現 `127.0.0.1:<port>/...oauth/authorize` 彈窗＝GCM 本機重新登入，不是外部威脅；用 `Get-NetTCPConnection -LocalPort <port>` 查沒程式在聽＝過期殘留可忽略。
- 🔴 兩台**不要同時改同一份檔案**（autopush 有 `pull --rebase --autostash` 重試，但同時改仍可能衝突）。
- hook 腳本訊息**刻意用純英文**（PS 5.1 無 BOM 會用 Big5 誤讀中文導致解析失敗）。

## 三層機制（各走各的，互不衝突）
| 層 | 觸發 | 做什麼 |
|---|---|---|
| Windows 本機 | `~/.claude/settings.json` SessionStart／Stop | `memory-autopull.ps1`／`memory-autopush.ps1` |
| Mac 本機 | `~/.claude/settings.json` SessionStart／Stop | `memory-autopull.sh`／`memory-autopush.sh`（顯式 `origin main`／`HEAD:main`，已 set-upstream） |
| 手機/雲端 | repo 內 `.claude/hooks/*.sh` | 有 `CLAUDE_CODE_REMOTE=true` 守衛，**只在雲端跑**，本機不觸發 |

## 設定也版控（`config/` 於記憶 repo）
- 結構：`config/mac/{settings.json, statusline-command.sh, hooks/*.sh}`；`config/windows/` **待建（.ps1）**。
- 機制：hooks ＋ statusline 用 **symlink**——真檔在 `config/mac/`，`~/.claude/` 底下是指過去的連結，改檔＝改 repo →自動 commit/push/pull＝即時雙向同步。
- `settings.json` **只做版控備份不自動回套**（Mac 指 .sh／Win 指 .ps1 不能共用），要還原手動 copy。
- 🔴 Windows 那台待做：把 settings.json＋hooks/*.ps1＋statusline.ps1 放進 `config/windows/`、autopush.ps1 加備份 settings 步驟。**改閘門邏輯要兩邊資料夾一起改。**

## Windows／Mac 差異
- 🟢 記憶（腦袋層）：已雙向自動同步，判斷/規則/風格本來就一樣。
- 🟡 hook／statusline（自動化層）：Mac 已於 2026/07/16 建好整套（completeness-gate／co-rule-gate／stock-gate／session-time／memory 同步／statusline，全部實跑 ExitCode 0）。
- 🔴 OS 綁死層不該硬抄：deny 黑名單（Mac `rm -rf`/`diskutil` vs Win `Format-Volume`/`diskpart`）、hook 副檔名（.sh vs .ps1）、路徑基底。
- ⚠️ Mac 那套是「依原意重建版」不是 Windows 逐字（當初貼文傳輸中大量截斷）。真要 byte 對齊，要在 Windows 說「比對設定」dump 原始 .ps1 校對。
- ⚠️ Mac statusline 的 `.rate_limits.*`／`.context.*` 欄位名是推測的，若額度% 沒顯示＝要拿 Windows 原檔校正。
- 🔴 **下次談到 Mac 同步先問「Mac 那邊弄完了嗎」**，別假設已完成。
- 成本註記：每個 UserPromptSubmit 閘門每輪都注入提醒（數百 token/輪）。Windows 這邊已改成 `gate-dispatcher.ps1` 模式偵測＋黏著，只噴有開的閘門。

## Mac 硬體與 VM（跟記憶同步不同件事）
- 家裡是 **Mac M1 Pro**（Apple Silicon），公司才是 Windows。
- 2026/06/22 決定從 macOS Ventura 13.5.2 **直接跳級更新到 macOS Tahoe 26.5.1**，走 GUI「系統設定→軟體更新」（不用終端機，避免重開機切斷 Claude Code session）。使用者自行決定不做 Time Machine 備份、已告知風險並接受。
- **Parallels Desktop 與 Windows 都是破解版**：macOS 大版本更新會讓破解配方失效 → 這是他長期不敢更新 macOS 的原因。現在很少用 Windows，**VM 重建暫緩**。
- 之後若要重啟 Windows VM（已驗證可行路徑）：改用 **UTM**（免費開源，官網 `mac.getutm.app`，⚠️別去 Mac App Store 那是付費版）＋ Windows 11 **ARM64** ISO 走一般下載頁 `microsoft.com/software-download/windows11`（⚠️別走 Insider Preview 網址，打不開）＋建 VM 選「Virtualize」非「Emulate」。
- **待辦**：Tahoe 更新完他想叫我做**硬碟清理**（重複檔/舊下載/不用的 App/大檔）。他提「清理」可直接接手，**刪除前先列清單給他確認**。

相關：[[feedback_mac_vs_windows_stock_selection]]、[[feedback_permission_tiers]]、[[reference_statusline_powershell_fix]]、[[project_gate_dispatcher_0731]]、[[reference_git_path_windows]]

## 🔴🔴 同一台機器同時開兩個 session 會互相踩（115.08.26 實例，非假設）
- 8/26 當天同時有三個寫入者在動 `Downloads\agent\計價回測工具\選股對帳紀錄.txt`：
  ①上午那個 session（269d12c5）②12:50 的看盤台排程 headless run（f89a3ffc）③我（2eb8fefd）。
- **13:39 上午那個 session 用「保留位元組 0~363990 的 head ＋ 第 934 行以後的 tail」重寫整份檔**，
  把它自己當天寫的三段（10:58 選股／11:25 國巨可以留嗎／2018 漲價循環實證）抽掉，
  同時刪掉 `選股逐檔明細_1150826.txt`。它有寫「保留其他 session 的段落」並自驗，**我的兩段確實沒被動到**。
- 🔴 **教訓不是「誰做錯」，是「按位元組偏移量重寫共用檔」這個手法本身很危險**：
  它假設別人沒有同時在寫。當天剛好沒撞到是運氣，不是設計。
- **往後對 選股對帳紀錄.txt 一律 append-only**（`cat >>` 或 `AppendAllText`），
  要移除舊段落就明講、單獨做一次，不要跟寫入混在同一道指令裡。
- **排查招式（有效，下次直接用）**：session transcript 在
  `.claude\projects\C--Users-Seal-Lo-Downloads-agent\*.jsonl`，一行一個事件。
  用 `ConvertFrom-Json` 取 `.message.content` 裡 `type=tool_use` 的 `input.command`，
  就能查出「是誰、幾點、下了哪一道指令改了這個檔」。檔案時間戳對不上時先查這裡，不要憑猜。
- **內容還救得回來**：被刪的三段在 269d12c5 的 transcript heredoc 裡是全文；
  `選股逐檔明細_1150826.txt` 的來源 `blocks0826.txt`(88KB) 還在該 session 的 scratchpad。
  🔴 但那是別的 session 刻意刪的，**未經使用者裁示不要自己還原**。
