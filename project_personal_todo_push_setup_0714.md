---
name: project_personal_todo_push_setup_0714
description: "個人待辦清單+手機自動推播系統已建好(2026-07-14),含Remote Control配對與雲端routine設定"
metadata: 
  node_type: memory
  type: project
  originSessionId: f3e27df5-0c8b-43bb-91bd-dc01d1f05414
---

使用者反映下班後容易忘記要做的事,已建好兩層系統解決。

**Why:** 使用者上班很有目標感,下班意志力耗盡容易忘事,需要把「記得要做」從腦袋搬到外部系統,分被動查詢+主動推播兩層。

**已完成:**
- 待辦清單本體:[[reference_personal_todo_list]],存記憶repo自動同步,手機/桌面共用
- 桌面推播設定已開(`/config` → Push notifications,`.claude.json` 的 `tengu_kairos_push_notifications: true`)
- 手機 Remote Control 已配對(`/remote-control` 指令完成,2026-07-14)
- 雲端 routine「晚間待辦提醒 20:30」已建立,id `trig_014NDWaJJdrTgBCgZftAwzVi`,cron `30 12 * * *`(UTC,對應台北20:30),每天讀 `reference_personal_todo_list.md`,有待辦才推播、空清單不推播不噪音,用 haiku 省成本

**How to apply:** 之後使用者說「幫我記一下 XX」就寫進 reference_personal_todo_list.md 的「目前待辦」區塊;完成的項目要主動刪掉/標記,不要一直堆積;使用者要改推播時間就用 RemoteTrigger action update 改 cron_expression。

✅(2026-07-14)實測全通:第一次配對失敗是因為 `/remote-control` 在桌面開了瀏覽器網頁版而非印QR碼給手機掃,使用者改用手機 Claude app→「Code」分頁→從session列表直接點選連上,才算真配對成功;配對成功後 RemoteTrigger action=run 手動觸發過一次,手機確實收到推播(含測試項目),已驗證整條「repo待辦→雲端routine→PushNotification→手機推播」管線可用。測試項目已從清單清除、repo已push。
