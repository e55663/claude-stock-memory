---
name: feedback_batch_todo_workflow
description: "使用者一次丟一堆檔→我自辨請款單/修改單/入預算+跑核對+打產出,問題全集中寫進docs/todo.md(問題/影響/建議方案/優先級),省額度不中途問"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0676a484-0801-42d0-a529-a623cedbbd43
---

**(6/22 定案)** 使用者新標準流程,為省額度(減少對話來回):

一次丟一堆檔 → 我自己分辨是請款單/修改單/入預算 → 跑完核對 → 所有問題集中寫進 `docs/todo.md`,**不在對話裡長篇列、不中途停下問**。使用者只看 todo.md,沒問題就收尾 clear。

todo.md 格式(每筆四欄):
- 問題
- 影響
- 建議方案
- 優先級(🔴/🟡)

**Why:** 多開視窗/長對話=同一桶額度更快見底([[reference_session_workflow_habit]]);把回報落成檔案比在對話裡反覆貼省很多。

**How to apply:**
1. 該打的產出照打不算「問你」——計價Excel、修改單memo直接動手做([[reference_billing_statement_template]][[reference_change_order_template]]),只動我說的([[feedback_only_do_whats_asked]])。
2. 🔴缺料/要確認的點也寫進 todo.md 當一筆(標🔴),**絕不自己填**([[feedback_flag_problems_with_source]]「絕不掰數字」);這樣全程不卡使用者、又不破絕不掰。
3. todo.md **永遠都產出一個檔**,沒問題也在開頭寫一行 `✅ 本批X張全部核對無誤,計價已打,整理夾已開在Downloads\…,待你確認歸檔`——讓使用者分得出「真沒問題」vs「我掛了」。
4. 每筆問題附出處(檔名+分頁+列格/PDF段)+對照基準([[feedback_flag_problems_with_source]])。
5. 附件查檢併進 todo.md 當一個區塊([[reference_billing_attachment_checklist]]),不另外在對話講。
6. 🔴**歸檔仍留使用者按**——整理夾開在Downloads([[feedback_stage_in_downloads_before_archive]])、計價打好,但不直接搬工地;todo.md最上面寫整理夾位置,使用者講「歸檔」才搬([[reference_site_archive_convention]])。

使用者最終動作只剩:丟檔 → 看 docs/todo.md →(沒問題)講「歸檔」+收尾+clear。
