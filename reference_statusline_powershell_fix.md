---
name: reference_statusline_powershell_fix
description: Status line(終端機底部模型/額度顯示列)改用PowerShell而非Git Bash的原因與現況;附帶4支hook檔案缺UTF8 BOM的批次修復
metadata: 
  node_type: memory
  type: reference
  originSessionId: 91fdb5f1-9d53-49d7-b478-62d6ccbb2de8
---

**(115.07.09)** Status line完全不顯示的根因:原本`~/.claude/statusline-command.sh`用Git Bash執行,每次呼叫要8~10秒(重複測3次都一樣,Cygwin環境啟動開銷),Claude Code的status line逾時機制等不到就直接放棄不顯示、不報錯,導致底部欄位空白。

**已修復**:改寫成原生PowerShell版`~/.claude/statusline-command.ps1`(用`ConvertFrom-Json`取代jq、`[char]27`組ANSI色碼取代bash轉義),`~/.claude/settings.json`的`statusLine.command`已指向新檔。速度壓到1.3~1.7秒(純PowerShell啟動本身就要0.8~0.9秒,是這台機器的地板,可能是防毒即時掃描,已經沒什麼再壓的空間)。舊的.sh檔案還在但沒被使用。

**附帶踩雷+批次修復**:改寫時PowerShell 5.1讀取新.ps1檔案時,因為沒有UTF-8 BOM,中文/特殊符號(█░📝等)讓parser整段炸掉(跟既有記憶「PS5.1雷:.ps1含中文一定要UTF8-BOM」同一個坑)。順手全面檢查`~/.claude/hooks/*.ps1`,發現`stock-gate.ps1`當時就是這樣壞的(每輪對話都在報hook error但沒人發現),另外`memory-sync.ps1`、`session-time.ps1`、`stock-conflicts-reminder.ps1`也缺BOM(只是還沒踩到中文字元位置去炸)。已用`[System.Text.UTF8Encoding]::new($true)`統一補上BOM,4支都驗證退出碼0正常執行。`memory-autopull.ps1`、`memory-autopush.ps1`本身不含非ASCII字元,沒有這個風險,沒動。

**How to apply**：以後新增/大改任何`.ps1` hook檔案,存檔前先確認有UTF8 BOM,別等它在使用者對話中噴錯才發現。
