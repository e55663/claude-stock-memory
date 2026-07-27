---
name: feedback_never_mix_bash_powershell_file_ops
description: "🔴🔴資料遺失事故:Bash建夾+PowerShell搬檔編碼不一致→Move-Item誤判成改名+覆蓋,5檔永久遺失;檔案操作一律純PowerShell+驗容器+逐檔驗落點"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e0ecc4d-2dee-4fc7-99db-a768616a42a7
  modified: 2026-07-27T03:10:16.308Z
---

🔴🔴 **115.07.27 資料遺失事故（我造成建鑫土方#4 五個檔永久遺失）**

**經過**：處理 141E 建鑫土方#4，我先用 **Bash `mkdir -p`** 建中文名整理夾，再用 **PowerShell `Move-Item -Destination $dir`** 迴圈搬 6 個檔進去。Bash 建的資料夾名與 PowerShell 字串的 Unicode 正規化（NFC/NFD）不一致 → PowerShell 沒認出資料夾已存在 → 把「搬檔進夾」逐一執行成「把檔案**改名**成資料夾同名」，第一個檔改名成 $dir，之後每個檔用 `-Force` **覆蓋** $dir，前 5 檔內容被連續覆蓋掉、只剩最後一檔。改名/覆蓋**不進資源回收桶**，Downloads 未被 OneDrive 同步，VSS 要 admin → 全機搜尋+回收桶(60筆)確認**無副本、永久遺失**。遺失：世峰聯單/出土月報/列控表/扣款單/宜蘭三星聯單（#4期，含最關鍵的列控表）。

**Why**：中文（尤其含全形、括號、`#`、雙空格）路徑跨工具會踩編碼；Move-Item 目的地若「不存在為資料夾」會靜默降級成「改名」，多檔迴圈就變連環覆蓋——完全無警告、無法復原。

**How to apply（鐵則，之後檔案操作一律照做）**：
1. 🔴 **檔案/資料夾操作一律純 PowerShell，絕不混用 Bash**（Bash 中文路徑本來就不穩，見 [[feedback_ps_chinese_literal_encoding]]）。建夾也用 PowerShell `New-Item -ItemType Directory`。
2. 🔴 建夾後**立刻 `Test-Path -LiteralPath $dir -PathType Container`** 確認「是容器」才可往裡搬；不是容器就停。
3. 🔴 搬檔**一次一檔**，每檔 `Move-Item -LiteralPath $src -Destination $dir` 後**驗證兩件事**：`Test-Path (Join-Path $dir 檔名) -PathType Leaf`（落夾內）+ `-not (Test-Path $src)`（根目錄已無）。禁止整批盲搬不驗。
4. 🔴 Move 到「檔案路徑」而非「資料夾路徑」時 `-Force` 會覆蓋——所以目的地永遠給**資料夾**、且先證明它是資料夾。
5. 全部路徑用 `-LiteralPath`（中文/全形/括號/雙空格）。

呼應 [[feedback_move_into_dir_verify_exists]]（本來就有「建夾用-Path+Test-Path驗證再搬」，這次事故=沒落實 + 還混了 Bash）、[[feedback_verify_after_batch_ops]]、[[feedback_stage_in_downloads_before_archive]]。
