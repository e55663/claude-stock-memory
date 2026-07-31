---
name: feedback-never-overwrite-user-edited-file
description: "0731事故—重建檔案蓋掉使用者在Word裡改好的版本;寫檔前必比對mtime/hash,且一律原地編輯不從範本重建"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7fc99aca-2fab-493a-8dbb-941f42704aa2
  modified: 2026-07-31T07:27:32.540Z
---

115.07.31 產會議紀錄 docx 時，我每次修改都「從範本複製一份新的覆蓋 → 重填所有欄位」。使用者中途在 Word 裡自己改過並存檔，我在 15:21 又覆蓋一次，他的編輯全部消失。查過 .asd／UnsavedFiles／~$ 鎖定檔／檔案歷程記錄／OneDrive，全部沒有，救不回來。

**Why:** 我手上一直有可偵測訊號卻沒用——我知道自己上次寫入的時間，只要覆蓋前讀一次 LastWriteTime 比對，就會發現檔案被別人動過。整份重建把「改一段」放大成「全檔置換」，任何外部編輯都會被無聲吃掉，而且不會報錯。

**How to apply:**
1. 產出交付檔（docx/xlsx/pptx）後，把該檔的 LastWriteTime + SHA256 記在心裡；下次要寫同一個檔前先重讀比對，不一致＝使用者動過，停下來問，不准直接蓋。
2. 修改既有檔一律**原地編輯**（Word/Excel COM 開檔改指定儲存格或段落），不從範本重建。真的需要重建，先另存 `_會議紀錄備份\檔名_yyyyMMdd_HHmmss` 再動，並事前告知。
3. 交付檔第一次產出後就建備份夾，之後每次改動前先備份，不是出事才補。
4. 這條跟 [[feedback_never_mix_bash_powershell_file_ops]] 同一類：檔案操作要有「動之前先確認現況」的動作，不能假設檔案還是我上次留下的樣子。
