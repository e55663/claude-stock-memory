---
name: feedback_delete_temp_backups
description: "我處理時自建的備份/暫存檔,任務完成不需要了就主動刪掉,別留在桌面/資料夾"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 150a22d6-ffb5-49db-8b24-b1d5c57d974f
---

**(2026/06/17)** 我為了安全在改檔(尤其COM寫Excel)前自建的**備份檔/暫存檔**,等任務做完、驗證沒問題、不需要了,就**主動刪掉**,不要留一堆在桌面或資料夾。

**Why:** 使用者不想桌面/資料夾被我的備份檔塞滿,看了煩、也分不清哪個是正式檔。

**How to apply:** 改檔流程=先備份→改→驗證→確認OK後刪備份。若還在等使用者確認可能要回退,就先留著、做完那一輪再刪。呼應 [[feedback_no_standalone_artifacts]](別自動產獨立檔)。⚠️只刪「我自己建的」備份/暫存,使用者本來就有的檔絕不亂刪([[feedback_only_do_whats_asked]])。

🔴**(2026/7/2再犯被唸)備份放scratchpad,別放原檔旁邊**:7/1改信用卡PPT/數字清單時把`_備份YYYYMMDD_HHMMSS`備份留在Downloads沒收→使用者嫌亂。改法:①備份一律建在scratchpad暫存區(不放桌面/Downloads原檔旁);②同一個session驗證完就刪,不留到下次session;③真要刪使用者資料夾裡的舊備份,先確認原檔存在且是最新版(size/時間較新)再刪,且丟資源回收桶(SendToRecycleBin)不永久刪,保留救回空間。本session的閎順/翔博計價本改檔已照此(備份放scratchpad+當場刪)。
