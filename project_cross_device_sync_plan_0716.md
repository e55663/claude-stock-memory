---
name: project_cross_device_sync_plan_0716
description: "讓Windows與Mac的Claude Code使用回饋一致的同步計畫;記憶已雙向同步(腦袋一致),還沒對齊的是本機hook/statusline那層;附兩台現況盤點與待補清單"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4ee29eff-a841-4549-9e11-0f7d643fa3a1
---

**目標(2026/07/16 使用者原話)**：讓 Windows 跟 Mac 在使用時「回饋一樣、不要支離破碎，哪些窗戶有哪些mac有」。核心觀念=選 GitHub repo `e55663/claude-stock-memory` 當單一真相，可攜的東西都收進去兩台各自拉，差異只剩 OS 綁死那幾項。呼應 [[feedback_cross_device_consistency]]。

**分層診斷（哪層一致、哪層碎）：**
- 🟢 **腦袋層＝記憶（127檔.md＋MEMORY.md）已雙向自動同步**：兩台開機 pull、關閉 commit+push 到同一 repo。判斷/知識/規則/講話風格本來就一樣。使用者感覺的「碎」不是這層。詳見 [[project_memory_sync_setup]]。
- 🟡 **自動化外掛層＝本機 hook / statusline，還沒對齊**：這是真正碎的地方，當初兩台各自臨時裝。
- 🔴 **OS 綁死層，本來就不可能一字一樣、也不該硬抄**：deny 黑名單指令（Mac `rm -rf`/`diskutil` vs Win `Format-Volume`/`diskpart`）、hook 副檔名（`.sh` vs `.ps1`）、路徑基底（`/Users/...` vs `C:\Users\...`）。

**Mac 現況（2026/07/16 實查 `~/.claude/`）：**
- ✅ `settings.json`：bypassPermissions＋skipDangerousModePermissionPrompt＋24條 deny＋theme=dark＋model=opus；inline SessionStart(git pull)/Stop(git commit+push) 記憶同步 hook。
- ✅ `full_market_scan.py`：全市場海選已共用（推 GitHub 兩台通用），見 [[feedback_mac_vs_windows_stock_selection]]。
- ❌ **無 `~/.claude/hooks/` 資料夾** → 選股完整性閘門、請款完整性閘門等 UserPromptSubmit gate 在 Mac 都不觸發。
- ❌ **無自訂 statusline** → Mac 用預設狀態列。
- 註：repo 內 `.claude/hooks/{session-start,stop-sync}.sh` 有 `CLAUDE_CODE_REMOTE=true` 守衛＝只在雲端/手機跑，本機不觸發（本機靠 settings.json inline 版）。

**Windows 有、Mac 缺，待補（依記憶，未經 Windows 實檔核對）：**
- `stock-gate.ps1`（UserPromptSubmit 第3條，選股完整性閘門）→ 見 [[feedback_stock_completeness_gate]]
- `completeness-gate.ps1` + `co-rule-gate.ps1`（UserPromptSubmit，請款完整性閘門）
- `statusline-command.ps1`（狀態列，PowerShell 版）→ 見 [[reference_statusline_powershell_fix]]
- 其他：`session-time.ps1`、`stock-conflicts-reminder.ps1`、`memory-autopull/autopush.ps1`
- ⚠️ 以上是憑記憶，實際要以 Windows 本機 `~/.claude/settings.json`＋`hooks/` dump 為準。

**下一步（既然兩台都在手邊）：**
1. 🔴 在 **Windows** 開 Claude Code 說「比對設定」→ 那台的我 dump Windows 的 settings.json＋hooks 整包，跟本檔 Mac 現況逐項 diff。從真實檔案對，不從記憶猜。
2. 互補齊：Windows 缺的從 Mac 補；Mac 缺的（stock-gate/gate/statusline）把 Windows `.ps1` 翻成 `.sh` 落到 `~/.claude/hooks/`，並 wire 進 Mac settings.json 的 UserPromptSubmit/statusLine。
3. wiring 是最後一步，等 Windows 對完再做，確保兩台真的同規格。
4. 🟢 Mac 已先建好 `~/.claude/hooks/` 骨架＋`stock-gate.sh`（內容依記憶預填），等 Windows 版一到就對齊定稿。

**✅(2026/07/16 晚 已在 Mac 建好整套本機自動化)** 使用者貼來 Windows 版規格要我照建，但貼文在傳輸中**大量截斷/損毀**（stock-gate 的 echo 跟字串斷行=語法錯、statusline 多個變數未定義+色碼壞、settings.json 掉了 command key）。已**不照損毀內容逐字抄**，改用「完好處保留＋依原意與記憶重建」做出可執行版，全部實跑驗證 ExitCode 0：
- `~/.claude/hooks/`：`completeness-gate.sh`(請款閘門,原文完整)、`co-rule-gate.sh`(修改單鐵則,補回被截的『既有單價追加』與④編號)、`stock-gate.sh`(選股閘門+對帳強制,重建)、`session-time.sh`(寫 `~/.claude/last-session-time` 供狀態列)、`memory-autopull.sh`/`memory-autopush.sh`(git 同步,🔴踩到坑:local main 一度沒 upstream→改用顯式 `origin main`/`HEAD:main`+已 `set-upstream-to=origin/main`)。
- `~/.claude/statusline-command.sh`：重寫的乾淨 bash 版,兩行(🚀✨模型/context bar/5h,7d額度 ‖ git分支+diff+專案/📝最後活動);額度與context欄位在 CC 沒提供時 graceful 略過。⚠️`.rate_limits.*`/`.context.*` 欄位名是照你貼文推的,若重開後額度%沒顯示=要拿 Windows 原檔的正確欄位名校正。
- `settings.json`：改成 script 版 hooks(SessionStart→autopull/Stop→autopush/UserPromptSubmit→4閘門)+statusLine;deny 併為 25 條(原24+`sudo *`);拿掉貼文殘缺的 `autoUpdatesChannel`;bypass/skipDangerous/theme/model 保留。JSON 驗證合法。⚠️要**重開 session** 才生效。
- 🔴**仍待做**:這些是「重建版≠Windows 逐字」。真要 byte 對齊,還是要在 Windows 說「比對設定」把原始 .ps1 dump 出來校對;另可把這些可攜 hook 收進記憶 repo 版控(制度性根治,目前只在 Mac 本地)。
- ⚠️成本:4 個 UserPromptSubmit 閘門每輪都注入提醒文字(約數百 token/輪),這是 Windows 本來就這樣;若嫌貴可改成關鍵字觸發。

**關聯**：[[feedback_permission_tiers]]（權限已對齊）、[[project_memory_sync_setup]]、[[feedback_cross_device_consistency]]、[[feedback_stock_completeness_gate]]。
