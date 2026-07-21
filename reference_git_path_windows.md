---
name: reference_git_path_windows
description: "Windows 上 git.exe 在 C:\\Users\\Seal_Lo\\AppData\\Local\\Programs\\Git\\cmd\\git.exe;115.07.21已加進User PATH,直接打 git 就能用,別再回報「git不在PATH」"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 807b00f8-5469-4abd-bde6-586a545e640b
  modified: 2026-07-21T09:43:44.920Z
---

**git.exe 位置**：`C:\Users\Seal_Lo\AppData\Local\Programs\Git\cmd\git.exe`（git version 2.54.0.windows.1）

115.07.21 已把 `...\Programs\Git\cmd` 加進 **User PATH**，新開的 shell 直接打 `git` 就能用。若某個 session 的 shell 還是找不到（PATH 是 session 啟動時抓的快照），當場補一句就好：

```powershell
$env:PATH += ';C:\Users\Seal_Lo\AppData\Local\Programs\Git\cmd'
```

**記憶 repo**：`C:\Users\Seal_Lo\.claude\projects\C--Users-Seal-Lo-Downloads-agent\memory` → `https://github.com/e55663/claude-stock-memory.git`（branch `main`）。SessionStart hook 自動 pull、Stop hook 自動 push，兩支 hook 本來就用完整路徑，**所以自動同步從來沒壞過**。

🔴 **教訓（115.07.21 使用者問「git不能處理好嗎」）**：我跑 `git status` 撞到 CommandNotFound，就在收尾時寫「git 不在 PATH，我無法手動 push」然後轉頭結束。錯兩層：①沒去找 git.exe 到底在哪（三秒的事）②把「我的工具鏈有問題」講成既成事實丟給使用者，而不是當場修掉。呼應 [[feedback_verify_after_batch_ops]]——回報前先問自己「這件事我是真的做不到，還是只是沒去試」。

相關：[[project_memory_sync_setup]]、[[feedback_cross_device_consistency]]
