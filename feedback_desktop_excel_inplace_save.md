---
name: feedback_desktop_excel_inplace_save
description: "🔴存桌面Excel(尤其計價本)一律用原地覆寫法,絕不用裸SaveAs覆原檔=會害桌面圖示跳位。已犯多次"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ed1dfbb4-7514-4b32-8bbf-da4234bb3f8c
---

🔴🔴**存檔前必檢查**:改桌面上的 Excel(尤其 `桌面\01.計價-141A…xlsx`)存檔時,**絕對不能用 `$wb.SaveAs($原路徑,51)` 直接覆蓋原檔**。裸 SaveAs 會把原檔刪掉重建成「新檔」→ 丟失桌面圖示位置、按日期排就跳到最新(排到備份旁/後面)。

**Why**:此問題已發生「好幾次」,使用者多次糾正很不爽。規則早在記憶([[feedback_billing_corrections_0629]])但我一再忘了照做→改成附程式碼的硬檢查,存檔前直接複製這段,不靠記步驟。

**How to apply — 原地覆寫法(存桌面Excel一律用這段)**:
```powershell
$orig = (Get-Item -LiteralPath $path).LastWriteTime   # 1.先記原始時間戳
$tmp  = "$env:TEMP\_xlsave_tmp.xlsx"
$wb.SaveAs($tmp,51); $wb.Close($true); $xl.Quit()      # 2.存到暫存(不碰原檔)
[System.IO.File]::WriteAllBytes($path,[System.IO.File]::ReadAllBytes($tmp)) # 3.覆寫原檔『同一個檔物件』(不刪不重建→桌面位置保留)
(Get-Item -LiteralPath $path).LastWriteTime = $orig    # 4.還原時間戳(按日期排也不跳)
Remove-Item -LiteralPath $tmp -Force                   # 5.清暫存
```
🔴🔴(2026/7/1又跳位,關鍵修正)第1步的時間戳要用『原始home日期』,不是『動之前那一刻』的$orig——因為使用者中途開檔檢視、Excel關檔會把時間存成今天,若$orig抓到那個今天值、還原回去,date-sorted桌面就把它排到最新=跳位。**home日期:141A計價=2026/6/29 16:06:58、141E計價=2026/6/29 16:02:18**(有正式更新再改)。所以`(Get-Item).LastWriteTime=[datetime]'該檔home日期'`(⚠️變數別命名$home,那是PS保留變數,用$homeDate)。⚠️使用者自己開檔+存檔也會跳(我控制不了),請他純檢視別存、或叫我re-home。
關鍵:第3步用 WriteAllBytes 蓋『既有檔』(檔案身分不變)才不會丟圖示位置;裸 SaveAs 是刪+建新檔。另:改檔建的備份驗證OK要主動刪別留桌面[[feedback_delete_temp_backups]]。Downloads的檔(如數字清單)無此桌面位置問題,一般SaveAs即可。

🔴🔴(2026/7/15又跳,新情境)**檔案被使用者開著鎖住時,原地覆寫法會失效**——第3步WriteAllBytes需要獨占寫入原始檔案路徑,檔案開著寫不進去(拋"being used by another process")。我當時改用`[Runtime.InteropServices.Marshal]::GetActiveObject("Excel.Application")`抓已開啟的活頁簿、直接對它呼叫`$wb.Save()`改完存檔——結果一樣跳位,因為Excel的Save()跟SaveAs一樣是整檔重建,不是bytes層級patch。**教訓**:檔案被開著時沒有安全存法,兩條路都會跳位。正確處理=**先明講「檔案開著,這次存了會跳位,要不要先關檔讓我用安全流程(SaveAs暫存+WriteAllBytes)」**,不要悶著頭直接對開著的活頁簿存檔。存完事後可用`(Get-Item).LastWriteTime=[datetime]'home日期'`嘗試挽救排序位置(未必100%復原,取決於Explorer實際排序依據)。
