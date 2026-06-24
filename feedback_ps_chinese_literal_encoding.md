---
name: feedback_ps_chinese_literal_encoding
description: PowerShell指令裡「我手打的中文字串」會偶發編碼壞掉→Test-Path/-like/Join-Path誤判False；用非中文屬性比對、磁碟讀取複驗
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d3d1e824-2d0f-4223-b25e-ffb5df3fb47f
---

**(2026/06/23 搬成駿全吊4檔時連環誤報)** 透過這個工具跑 powershell.exe，**我在指令裡手打的中文字串字面值會偶發編碼損壞**，導致 `Test-Path -LiteralPath $中文路徑`、`-like "*中文*"`、`Join-Path $dir $中文檔名` 對「明明存在的中文檔」誤判 False／命中0；但 **`Get-ChildItem` 直接讀磁碟回來的中文檔名是正確的**（Open/Read 用整段中文完整路徑也多半成功）。同一段碼跑兩次結果會矛盾＝就是這個編碼不穩，不是檔案真的沒搬到。

**Why:** 6/23 搬 4 個成駿全吊檔，連 3 次驗證都誤報「root還有殘留、整理夾空」，其實第一次就搬好了，差點重複搬蓋檔（呼應 [[feedback_move_into_dir_verify_exists]] 掉檔雷）。

**How to apply:** ①搬/找檔別用我手打的中文做比對鍵→改用**非中文屬性**(檔案大小Length、LastWriteTime時間窗、副檔名)或直接 pipe `Get-ChildItem` 物件的 `.FullName` 去 Move。②最終一定用**磁碟讀取(Get-ChildItem)＋大小複驗**確認整理夾有/根目錄無，別信中文-like的殘留報告。③讀中文內容照舊用 WebClient/Console UTF8（見 CLAUDE.md COM雷）。
