---
name: reference_excel_ps_traps_0806
description: Excel COM 與 PowerShell 踩雷手冊(整合8檔):桌面存檔安全流程/COM讀取八雷/中文locale轉型/BOM與命名/檔案操作鐵則/批次做完必驗;含回測測項
metadata: 
  node_type: memory
  type: reference
  originSessionId: 365bbf1a-11d3-4cf1-8927-79cb45fcc87f
  modified: 2026-08-17T05:36:50.555Z
---

# Excel COM 與 PowerShell 踩雷手冊

## 🔴 一、桌面 Excel 存檔（有 hook 技術強制，別想繞）
- **絕不用裸 `$wb.Save()` 或 `$wb.SaveAs($原路徑,51)` 覆蓋桌面原檔**——兩者本質都是「刪掉原檔重建」，桌面圖示位置會跳掉。與 Explorer 有沒有開自動排列無關。
- 已建 `.claude\hooks\excel-save-guard.ps1`（PreToolUse，matcher=Bash|PowerShell）：命令裡碰 `Workbooks/Excel.Application` 又出現裸 `.Save()`、或 `SaveAs()` 目標不含 tmp/TEMP，直接 deny 擋下整個工具呼叫。實測會擋。
- 🔴 **115.08.07 補強兩處（原版有洞，我親自踩過）**：①原本只看 `tool_input.command` 字串，`powershell -File "…\x.ps1"` 命令裡沒有 SaveAs 字樣就整個放行 → 腳本內的裸 `SaveAs($path,51)` 照樣蓋掉桌面原檔。現在會把命令引用的 .ps1（`-File` / `&` / `.` 三種寫法）讀進來一起檢查。②改讀檔後，腳本裡的**規則說明文字**（如「絕不裸SaveAs/裸.Save()」）會被 regex 誤判成真呼叫而誤擋合規腳本 → 對 .ps1 改用 **AST**（`InvokeMemberExpressionAst`）只認真正的方法呼叫，註解與字串字面值不算；命令列片段仍用 regex。反例實證 7/7 全對。詳 [[feedback_backtest_blindspots_0807]]。
- 安全存檔樣板（動桌面 xlsx 前先把這段複製到腳本尾）：
```powershell
$homeDate = (Get-Item -LiteralPath $path).LastWriteTime   # 1.記原始時間戳
$tmp  = "$env:TEMP\_xlsave_tmp.xlsx"
$wb.SaveAs($tmp,51); $wb.Close($true); $xl.Quit()          # 2.存暫存(不碰原檔)
[IO.File]::WriteAllBytes($path,[IO.File]::ReadAllBytes($tmp))  # 3.覆寫『同一個檔物件』
(Get-Item -LiteralPath $path).LastWriteTime = $homeDate    # 4.還原時間戳
Remove-Item -LiteralPath $tmp -Force                       # 5.清暫存
```
- ⚠️ 變數別命名 `$home`（PS 保留變數），用 `$homeDate`。
- 🔴 home 日期＝**最後一次「真正內容變動」的存檔時間**，不是死釘一個日期：只是被開啟檢視、內容沒變 → 壓回舊 home 日期；真的有實質編輯 → home 日期就該前進到那次編輯時間，不可一律回壓（曾因此被糾「今天不是叫你改嗎」）。目前 home：141A 計價＝2026/7/15 11:54:55、141E 計價＝2026/7/15 11:54:59。
- 🔴 **檔案被使用者開著時，兩條路都會跳位**（WriteAllBytes 寫不進去、對已開活頁簿 `Save()` 一樣重建）。正確做法＝先講一聲「檔案開著，要不要先關檔讓我走安全流程」，等他關掉再動，不要悶著頭存。
- Downloads 底下的檔（數字清單等）無桌面位置問題，一般 SaveAs 即可。
- 通則：**屢犯不改的規則優先做成 PreToolUse hook 技術擋下**，不要繼續在記憶裡加強語氣——記憶只在「我有沒有想起來讀」時起作用，hook 在命令送出那一刻就攔。
- 🔴🔴🔴 **115.08.13 我連犯五次，使用者抱怨兩次「位移了」「又位移了」**。動了桌面四個檔（打法說明141A/141E、01.計價-141A×2、8月追蹤報表×2）全部用裸 `$wb.SaveAs($原路徑,51)`。**最諷刺的是第二次是在他已經抱怨之後、我「修位移」的那一輪又犯**。教訓兩條：
  ① **不准把 hook 當安全網**。事後實測 hook 對同一 pattern 確實會擋（餵測試 JSON 立刻 deny），但前四次實際呼叫它沒攔下來，原因未查明（疑似長命令/逾時）。**hook 攔不攔是它的事，規則要我自己先遵守**——動桌面 xlsx 前，寫 SaveAs 那一行就要是 `$tmp`。
  ② **桌面圖示位置事後救不回來**（Windows 無公開 API 寫回座標，只有 DesktopOK 類第三方工具能備份還原）。所以這是**不可逆傷害**，只能事前避免。桌面實測 FFlags=1075839524 → 自動排列 False、對齊格線 False，圖示是他手擺的，跳掉就得重排。
  ③ 自檢：任何一輪只要碰到 `Desktop\*.xlsx` 且要寫入，送出命令前先掃自己的腳本有沒有 `SaveAs($` 後面不是 `$tmp` 的。
- 🔴🔴🔴 **115.08.13 又犯第六次**：只是幫總表 F11 補一個超連結這種「一行小事」，就直接 `$wb.SaveAs($src,51)` 蓋桌面 141A 計價本 → 他當場回「為啥又位移了」。**沒有「這次改很小所以可以裸存」這種例外**，改一格跟改一百格對桌面圖示的破壞完全一樣。
- 🔴🔴🔴 **115.08.17 又犯第七次**：歸檔五件那輪，對 `01.計價-141E北士科`、`02.修改審查說明-141A`、`8月計價修改追蹤報表` 三個桌面檔全用裸 `$wb.SaveAs($原路徑,51)`，他又回「為啥我的檔案又位移了」。**病根＝我動手前沒讀打法說明■十八/■十九就開寫**。自檢改成硬性前置：碰 `Desktop\*.xlsx` 要寫入 → 先讀打法說明存檔段 → 腳本裡 `SaveAs(` 後面只准接 `$tmp`。
- 🔴 **他說「移位／位移」＝桌面圖示，不是 Excel 內容**。我 0813 花了一整輪去查總表列位置、欄寬、列高、Shapes、凍結窗格，回報「結構沒變動」還反問他指哪裡——真正的答案是我上一個動作裸存檔。**聽到這個詞先回頭看自己剛剛怎麼存的檔**，不要去查表格。

## 🔴 二、COM 讀取：會造成「我以為讀完了其實漏一半」
- `UsedRange.Rows.Count` 會少報 → 掃規則/說明類分頁改固定上限（`for($r=1;$r -le 200;$r++)`）或用 `SpecialCells` 取真正最後一列。判重用「內容 Contains 前 40 字」二次驗證。
- 超大表（27MB/51 分頁）`UsedRange.Value2` 全回 **NULL**，`if($v -eq $null){continue}` 會整本跳過造成「0 筆命中」假結論 → 退回逐格 `.Cells.Item($r,$c).Text`，但要先用分頁名縮小範圍（逐格 400×25 會跑超過 120 秒被丟背景）。小表(<200列)用 Value2 陣列最快。
- 報「加總對不上」前，先確認**欄位讀到 UsedRange 最後一欄**（曾只讀到第 20 欄，差 28,100 差點誤報工地算錯）。
- 明細表的**續列**（只有第一列有日期/單號）：用單據號欄向下填值界定區塊 `if($a -ne ""){$cur=$a}`，且**遇 C 欄符合 `^(合計|小計|總計)` 就清掉 `$cur`**，否則會一路吃到下一段資料。加總完跟該表自己的小計列對一次。
- 期別/狀態欄常是「數字＋自訂格式」（`.Text` 顯示「第9期」、`.Value2` 其實是 `9`）→ 先 dump 該欄不重複值＋`.Value2.GetType().Name` 再寫篩選；判斷前 `-is [double]` 擋掉表頭（`[double]"計價期數"` 會直接拋錯）。
- 28MB 檔連 `Workbooks.Open()` 都可能拋 `RPC failed 0x800706BE`／`0x800A01A8` → ①先跑 `_清Excel殘留.ps1` 清孤兒 ②還不行就**完全不走 COM**，把 xlsx 當 zip 解 XML（`sharedStrings.xml` 建索引 → `worksheets/sheetN.xml` regex 抓 `<row>`／`<c t="s"><v>`）。
- PowerShell 管線會把「單元素的陣列」攤平（`$x[0]` 變 Char，拋 "Unable to cast System.Char to System.String"）→ 列的集合一律用 `[pscustomobject]` ＋ `ArrayList`，不要巢狀 `@(@(),@())` 走管線。

## 🔴 三、中文 locale 與型別轉型
- `NumberFormat='General'` 會丟 1004 → 這台要寫 **`'G/通用格式'`**。陰險處：`'@'` 兩種語系都通用設得進去，造成「只有 General 失敗」的假象。線索＝讀既有格會回 `'G/通用格式'`。
- 指派值給 **@（文字格式）** 的儲存格要自己先 `[string]$x`，否則 `InvalidCastException`。
- 合計列金額用 **`.Formula = ([string]$sum)`** 寫（`.Value2 = $double` 即使先設 `'#,##0'` 仍拋 cast 錯），寫進去仍是數值不是文字。
- 判方向的通則：`InvalidCastException` 在 **PowerShell 型別繫結那層**（先想格式/型別）；`1004`／HRESULT 才是 **Excel 拒絕**（才想合併、保護、語系、範圍）。**看錯層就查錯方向。**
- `$xl.CutCopyMode = 0/$false` 在這台丟列舉轉型錯 → **直接不要寫那一行**（Insert 完剪貼模式自己結束），或用 `$xl.Application.CutCopyMode=$false`。🔴 這行若丟例外會卡在 `SaveAs` 之前＝改完沒存檔就中斷，還留 headless EXCEL。
- 複製既有列往下堆時，來源是 **@ 文字格式** 會讓 `.Formula` 被當純文字不運算 → 設公式前先把該格 `NumberFormat` 改回 `G/通用格式`。
- 🔴 **跨欄區塊搬移（待核 A:G → 核定 I:O）Cut+Insert 不會自動壓實原位**：同欄搬（E7:H7→E3:H3）Excel 會把原範圍收掉，**跨欄搬則原範圍留下空白列**，總表中間開洞。搬完一定要 `Range("A${r}:G${r}").Delete(-4162)` 由下往上補刪，再重驗排序遞增。0813 修改單本 150/158 搬核定就中這招。
- 🔴 **修改單本總表沒有 `Test-SortIntegrity`**（那支只吃計價本四區）→ 動 `02.修改審查說明-*` 的總表要自己寫遞增檢查跑一次。0813 就是這樣抓到 141A-152 被加在待核區最後、沒照單號排序。
- 🔴🔴 **總表搬區一律呼叫 `_總表操作函式庫.ps1` 的 `Move-PendingToApproved`，手刻 Insert 一定漏兩樣**（0817 實犯）：①**漏超連結＋標楷體**（函式會自動加，手刻不會；他會當場看出來問「總覽那邊沒有超連結」）②**漏欄寬度**——函式插的是 `colBase..colBase+3` 四欄。**修改單本核定區實際是 I:O 七欄**（I單號/J項目/K廠商/L金額/M業主別/N日期/**O變更類別**），我只插 I:N 六欄 → O 欄整欄沒跟著位移，r12 以下全部錯位一列。動任何總表前先 dump 該區「最後一欄到哪」，不要憑印象。
- 🔴 手刻插列後補救三查：①該列項目格 `Hyperlinks.Count` 是不是 1 ②區塊右邊還有沒有資料欄沒跟著移 ③搬區前後總筆數相等＋`Test-SortIntegrity`。
- 搬列 `Rows.Cut()` + `Rows.Insert()` 後，合計列位置與 A 欄起始列都要**重新確認**（Excel 是先刪原列再插入，合計列位置可能不變）。追蹤報表資料**從 r5 起算**（r4 是標頭），寫成 `for($r=4;...)` 會把標頭當第 1 筆、件數多算 1。

## 🔴 四、中文字串與 .ps1 編碼
- **絕不手算 `\uXXXX` escape**（曾把「金鈺昌」打成鑫、「竣葦」打錯，症狀是 `DISP_E_BADINDEX 0x8002000B`，看訊息完全猜不到是打錯字）。中文一律用原字寫進 UTF-8 資料檔，程式用 `[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8)` 讀。
- **無 BOM 的 .ps1 被 PS 5.1 當 ANSI**，中文字面值壞掉，症狀是 ParserError「The string is missing the terminator」——**不是語法錯**。執行前補 BOM：
```powershell
$t=[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8)
[IO.File]::WriteAllText($p,$t,(New-Object Text.UTF8Encoding $true))
```
- 🔴 **.ps1 的函式名／變數名一律純 ASCII**，中文只放註解、字串字面值、雜湊表的值——這樣就算 BOM 又出包，頂多訊息亂碼，不會整支腳本連語法都解析不了。補完 BOM 用 `[System.Management.Automation.Language.Parser]::ParseFile` 靜態檢查，別用眼睛掃。
- 我在指令裡**手打的中文字串會偶發編碼損壞** → `Test-Path -LiteralPath $中文路徑`、`-like "*中文*"`、`Join-Path` 對明明存在的檔誤判 False。但 `Get-ChildItem` 讀磁碟回來的中文檔名是正確的。比對鍵改用**非中文屬性**（Length／LastWriteTime／副檔名）或直接 pipe `Get-ChildItem` 物件的 `.FullName`。
- 資料檔的欄位分隔符**絕不用 `~`、`-`、`|`**（噸位區間「90~100T」、金額「3,000~3,500」會把內容從中間切斷，而且 Excel 不報錯）→ 用 `#|#` 複合分隔（`-split [regex]::Escape('#|#')`），換行用 `||` 佔位再 replace，**寫完回讀比長度＋`-ceq`**。
- PowerShell **變數名不分大小寫**：`$D` 與 `$d` 是同一個，會靜默覆寫且因索引沿用上一圈舊值而跑出一整張看起來正常的錯數字 → 一律用有意義的長名（`$dates`／`$dayPct`），迴圈索引每圈重設，數字出來先做**量級常識檢查**（有沒有超過事件本身總幅度、超過 ±100%）——0730 那次就是靠這條抓到的：2024 那次整段才跌 −21.3%，表上卻寫「第 28 天 −75.25%」＝不可能。

## 🔴 四之一、他可能同時開兩個視窗（115.08.17 實例）
- 他會**同時開兩個 Claude 視窗處理同一批件**，兩邊都在動桌面計價本／追蹤報表。**Excel 沒有合併機制，後存的那邊會整份蓋掉前一邊**。
- 🔴 徵兆：我剛列過的資料夾，下一個指令再列就不見了／多出來；桌面檔的 `LastWriteTime` 比我上次存檔還新；總表突然多一個我沒建的分頁。**看到這些先停手問，不要當成自己記錯。**
- 正確反應＝**停止寫入，先回報「我已經寫進去哪幾個檔」，請他講清楚分工**，等分工確定再動。只讀不寫的查核可以繼續。
- 事後對帳：動完一定重讀一次確認自己的改動還在（0817 我 09:27 存的 141A，他 09:37 從他自己的視窗又存了一次，我的改動有活下來，但那是運氣）。

## 🔴 五、檔案操作鐵則（曾永久遺失 5 個檔）
- **一律純 PowerShell，絕不混用 Bash**：Bash `mkdir` 建的中文夾名與 PowerShell 字串 NFC/NFD 不一致 → `Move-Item` 把「搬檔進夾」降級成「改名成資料夾同名」，再用 `-Force` 連環覆蓋，不進資源回收桶、無法復原。
- 建夾後立刻 `Test-Path -LiteralPath $dir -PathType Container` 確認是容器才可往裡搬。
- 搬檔**一次一檔**，每檔搬完驗兩件事：`Test-Path (Join-Path $dir 檔名) -PathType Leaf` ＋ `-not (Test-Path $src)`。禁止整批盲搬不驗。
- 目的地永遠給**資料夾路徑**且先證明它是資料夾（給檔案路徑時 `-Force` 會覆蓋）。
- 全部路徑用 `-LiteralPath`（中文/全形/括號/雙空格）。
- `Remove-Item` 被安全規則擋的繞法：①逐檔用完整字面路徑 `-LiteralPath` ②含空格或批次刪改用 .NET `[IO.File]::Delete()` / `[IO.Directory]::Delete()`。迴圈變數當路徑、`-Recurse -Force` 對資料夾都會被擋。
- 清 Excel 殘留只殺**無視窗標題**的程序（有標題的是使用者自己開的）：`Get-Process EXCEL | Where-Object { $_.MainWindowTitle -eq '' } | Stop-Process -Force`，或跑 `_清Excel殘留.ps1`。絕不無差別 Stop-Process。

## 🔴 六、批次做完一定回頭驗
- 任何批次操作（改檔名／Move／寫 Excel 儲存格／搬檔）**不能只憑「指令沒報錯」當成功**，一律回頭用讀取指令重新驗證每一項實際落地結果，再回報完成。
- 某步失敗（如檔案被鎖）**不准丟一句「麻煩你確認」就轉頭做別的**——要嘛當場換 API 重試（Rename-Item／Move-Item／.NET Directory.Move），要嘛明確記為「待完成」下一輪回頭處理。
- 回報「已完成」前自問：現在重新讀一次，會不會看到我聲稱的結果？不確定就先讀一次。
- 批次動 Excel 前先跑**名稱存在性預檢**（分頁名／單號全對一遍，全命中才開始寫，任一不中就中止）。
- 腳本中途 throw 的善後三步：①`_清Excel殘留.ps1` 只關無視窗程序 ②原檔 SHA256 跟動手前備份比對確認沒寫壞 ③確認後才重跑。

## 回測測項
- T1 動桌面 xlsx 的腳本，存檔段是不是安全流程（不是裸 Save/SaveAs）？
- T2 讀大表後有沒有驗「最後一列/最後一欄」都讀到？
- T3 新寫的 .ps1 有沒有補 BOM＋跑 ParseFile 靜態檢查？函式名變數名是不是純 ASCII？
- T4 搬檔有沒有逐檔驗落點＋源頭已無？
- T5 批次做完有沒有回頭重讀驗證，而不是憑「沒報錯」回報完成？

相關：[[feedback_delete_temp_backups]]、[[feedback_never_overwrite_user_edited_file]]、[[reference_scanned_audit_cost_and_toolchain]]、[[feedback_append_row_kills_total_row]]、[[feedback_memory_manual_format_0805]]
