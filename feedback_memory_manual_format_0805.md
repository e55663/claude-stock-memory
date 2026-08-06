---
name: feedback_memory_manual_format_0805
description: 115.08.05使用者定|記憶檔與打法說明一律寫成「手冊」不是日誌:第一層現行規則每條一行含實際字串、第二層回測測項、敘事一律砍
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 365bbf1a-11d3-4cf1-8927-79cb45fcc87f
  modified: 2026-08-06T08:08:10.961Z
---

# 記憶／打法說明＝手冊，不是日誌

## 現行規則（寫任何記憶檔或打法說明條文前讀這層）
- 🔴🔴 **新規則預設「加進既有主題手冊」，不是開新檔**。開新檔前先問：這條屬於哪本手冊？找得到對應段落就加一行進去（地址成本 0）；真的沒有任何手冊裝得下，才開新檔。**每開一個新檔就是永久多 62B 的索引成本，而且會開始跟別的檔重複。**
- 現有主題手冊（新規則先往這裡塞）：請款＝`reference_billing_memo_standard_template`／`reference_billing_book_format_rules`／`reference_attachment_checklist_0806`／`feedback_status_sync_and_totals_0806`／`feedback_hangtong_existence_gate`／`feedback_self_vs_deduct_contract`／`feedback_self_audit_no_crutch`；流程＝`reference_archive_workflow_0806`／`reference_change_order_template`／`reference_approval_authority_table`；工具＝`reference_excel_ps_traps_0806`／`feedback_backtest_discipline`；投資＝`reference_stock_strategy_library`／`feedback_crash_playbook_0806`；環境＝`reference_model_cost_and_dispatch_0806`／`project_cross_device_setup`；習慣＝`feedback_work_habits_and_output_0806`。
- 檔案固定兩層：`## 現行規則` 在最上面（動手前只讀這層）、`## 回測測項` 在最下面。其餘一律砍。
- 現行規則每條**壓成一行**，內容＝「現在該怎麼做」，不帶「我當初怎麼錯的」。
- 有固定文字的規則，直接把**字串本身**寫進去，不要描述它。範例：行通表句固定一行 → `單價與X季行情通報，{符合／部分符合(一句話帶過)}`。
- 教訓要保留的是**判準**，不是事件。事件經過刪掉，只留「什麼情況下會判錯、正確判法是什麼」，一樣壓成一行。
- 一次性盤點快照（某日幾件、某日誰在跑）＝刪，需要時重跑一次掃描。
- 被明文作廢／取代的條文＝刪，不留考古層。同主題散在多處＝合併成一條。
- 條號當錨點：壓縮時**不重編號**，寧可留號碼空洞，也不要動編號體系（全書交叉引用會全錯）。
- 回測＝「之前犯的錯立下的規則，這次有沒有做到」的逐條檢查，不是重述故事；每條測項要能指出「該改哪一格」。
- 🔴🔴 **合併多檔時，刪除清單只能放「已經讀過全文、且確認內容真的併進去」的檔**。0806 連犯兩次：把 `feedback_check_landed_state_before_reaudit`（開審前四查）與 `feedback_missing_items_note_location`（缺件只寫 M 欄+txt 不進 memo）列進刪除清單卻沒讀過內容，兩條規則直接消失，事後才從 git 取回。**憑 description 判斷「應該已經被涵蓋」是不夠的。**
- 🔴 回測的**已知盲區**：`_記憶壓縮回測.ps1` 比對的是硬 token（數字/條號/公式/檔名/百分比），擋得住這些遺失，但**擋不住純中文敘述的規則被整條刪掉**——上面那兩條都是回測 PASS 但規則其實掉了，是人工發現的。所以合併後除了跑回測，還要自己回頭數一次「原檔有幾條規則、新檔有幾條」。

## 🔴 索引分兩層（0806 建）
- **`MEMORY.md`（開場強制載入）只留工作核心**：最高鐵則／請款計價／修改單入預算／檔案操作／歸檔／進行中批次。
- **`INDEX_ALL.md`（開場不載入）放投資／環境系統／個人生活**。
- 觸發：`gate-dispatcher.ps1` 的 tier2 偵測到相關關鍵字就噴一行提醒去讀第二層；MEMORY.md 末尾也寫死指標。**MEMORY.md 查無某條規則時，不准直接說「沒有這條規則」，要先讀完 INDEX_ALL.md。**
- 為什麼要分：索引的成本 **35% 是檔名本身**（164 個連結平均 62B/個，光地址就吃掉 10.2KB），每多一個記憶檔就自動從「規則描述」的額度裡扣。分層讓開場只付工作核心那份。

## 哪些檔是系統定義、哪些是我們自訂（0806 使用者問，避免誤改）
- **系統定義，改名或搬位置就失效**：`MEMORY.md`（開場唯一自動載入的索引）／家目錄 `CLAUDE.md`／`memory\` 資料夾位置（hook 與 settings 寫死）／每個記憶檔的 frontmatter（系統靠 `description` 判相關性）。
- **純自訂約定，系統不認識**：`HANDOFF.md`、`INDEX_ALL.md`（都是靠 MEMORY.md 掛連結才會被讀到）、`AGENTS.md`、`README.md`、檔名前綴 `feedback_`／`reference_`／`project_`（系統只看 frontmatter 的 `type`）。
- 🔴 **開場自動載入的只有 MEMORY.md 一個**。其他 md 不管建幾個，都要「有人叫我去讀」才會讀到——`macro_themes.md` 曾不在索引，我開場完全不知道有那張選股必看的主線表。
- 使用者可以自己建 md 丟進 `memory\`＋在 MEMORY.md 掛一行（成本約 62B），我下次開場就知道它存在。他也可以直接改任何記憶檔的內容，改完的版本為準（見 [[feedback_user_edit_implies_rule_0730]]）；只是要在同一個視窗講一聲，避免兩邊同時改撞 git。

## 🔴 索引不再往下拆（0806 決定，別重新討論）
使用者問「請款一個 md、投資一個 md、修改單一個 md 這樣分不是更好」。**答案是現在不用再拆**：
- 分的維度要用「**開場需不需要知道**」，不是「主題」。按主題拆會把每天在用的請款 35 行也移走，變成每件事都要先繞一圈去讀索引才會做，多一個「我忘記去讀」的破口。
- 現況餘裕夠：MEMORY.md 10,172B／上限 17,000。新規則改成加進既有手冊後，索引不再隨規則數成長（估一年 +20KB 全長在手冊內部）。
- 要再拆的時機由 `memory-health.ps1` 通知（>16,000B 或檔數 >150），不用預先拆。
- 🔴 他更該做的是**加內容型 md**（本月待辦／長官特殊要求／常用檔案位置），不是拆索引。

## 自動體檢（0806 建，不再靠使用者想到才做）
`\.claude\hooks\memory-health.ps1` 掛 SessionStart，**開場自動量、超標才輸出、沒事完全靜默**。五個門檻：
- MEMORY.md > 16,000B（上限 17,000，超過開場被截斷）
- 記憶檔總量 > 900KB
- 索引有死連結（檔刪了索引沒清）
- 有檔不在索引裡（＝開場看不到＝死記憶）
- 案件狀態檔 > 8 個（該依「歸檔＝結案」逐一清）

🔴 這是把「記憶瘦身」從『使用者哪天覺得肥了才問』變成『超標會自己講』。同理適用其他屢犯規則：**能做成 hook 就別只寫在記憶裡**，記憶只在「我有沒有想起來讀」時才起作用。

## 回測測項
- T1 檔案第一段是不是「現行規則」單行條列？（有敘事段＝FAIL）
- T2 每條規則是否可直接照做（含實際字串／數字／位置），不需要再讀下文才懂？
- T3 檔內有無日期流水帳、過期快照、「我被罵」的過程？（有＝FAIL）
- T4 壓縮後規則條數是否 ≥ 壓縮前的有效規則數？（掉規則＝FAIL，只准掉字不准掉規則）

相關：[[feedback_backtest_discipline]]、[[project_taofa_compression_0805]]（打法說明四份已壓完）、[[feedback_session_cost_and_memory_slimming]]、[[feedback_user_edit_implies_rule_0730]]

工具：`Downloads\agent\計價回測工具\_記憶壓縮回測.ps1`（從 git 取壓縮前版本比對硬 token，分規則層／案例層；已判定可刪的寫進同目錄 `_記憶壓縮回測_已判定.txt` 附理由，回測才收斂得到綠）。
