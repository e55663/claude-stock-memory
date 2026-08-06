---
name: feedback_archived_means_closed_0806
description: "115.08.06使用者定|已歸檔=結案=OK,不用留批次狀態記憶檔;批次跑完只留還沒歸檔的,歸檔當下就刪該案記憶"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 365bbf1a-11d3-4cf1-8927-79cb45fcc87f
  modified: 2026-08-06T01:40:45.837Z
---

# 已歸檔＝結案，不留歷史批次檔

## 現行規則
- 🔴 **案子歸檔＝結案＝沒問題**。歸檔後那件的批次狀態記憶檔（`project_billing_*`）**直接刪掉，不用留**。
- 批次跑完只保留「**還沒歸檔**」的案子的記憶檔；一歸檔就把該檔刪掉，同時拿掉 MEMORY.md 索引行。
- 不要為了「保存未結的錢」而留歷史批次檔——錢的問題該在歸檔前解決，歸檔就代表使用者已經放行。
- 收尾寫記憶時，問一句「這件歸檔了嗎」：歸檔了 → 不寫記憶檔；沒歸檔 → 才寫，且只寫卡在哪。
- 這條同樣適用修改單、入預算的個案狀態檔。
- 規則層／通則（打法說明、feedback、reference）不受影響——刪的只有「某天某批某案跑到哪」這種狀態日誌。

## 已執行
115.08.06 一次刪掉 31 個歷史批次／個案檔（125.9KB，涵蓋 0618~0803）。保留 6 個仍未歸檔的：0805 批次、0804 批次、銘亮#11、平安#15、安達#1、銓億#1。

## 回測測項
- T1 收尾時新增的 `project_billing_*` 記憶檔，對應案子是否真的還沒歸檔？（已歸檔還寫＝FAIL）
- T2 歸檔動作完成後，該案的記憶檔與 MEMORY.md 索引行有沒有一起清掉？
- T3 memory 目錄裡有沒有殘留「案子已歸檔」的批次狀態檔？

相關：[[feedback_memory_manual_format_0805]]、[[feedback_session_cost_and_memory_slimming]]、[[project_download_staging_dedup_workflow]]、[[reference_site_archive_convention]]
