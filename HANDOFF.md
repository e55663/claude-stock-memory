# 換手交接紀錄

規則：收工前在**最上面**新增一段。接手的一邊開場先讀最新一段，不要重問已經決定過的事。
格式：`## YYYY-MM-DD HH:MM ｜ Claude 或 Codex`，底下寫「做了什麼／停在哪／下一步／待裁示」。

---

## 2026-08-04 14:01 ｜ Codex

**做了什麼**
- 依使用者指定順序，完整讀取共用規則正本 `AGENTS.md`、業務規則正本 `C:\Users\Seal_Lo\CLAUDE.md`、索引 `MEMORY.md` 與本交接檔，完成 Codex 自我確認。
- 核對目前實際權限：本次 Codex writable roots 只有 `C:\Users\Seal_Lo\Downloads\agent` 與本記憶庫，不能寫 Desktop，也不能寫 `Downloads` 中工作資料夾以外的位置；這與 `AGENTS.md`「兩邊的能力邊界」及上一段 13:45 交接所載的測試結果不一致。
- 發現業務規則衝突：`C:\Users\Seal_Lo\CLAUDE.md`「商業規則（工地行政）」仍寫核決層級包含執行副總；`MEMORY.md`「最高位階鐵則」則明載工地流程沒有執行副總，兩者不一致。

**停在哪**
- 自我確認與交叉比對完成；未修改共用規則或業務規則正本。

**下一步**
- 後續任務依本庫索引選讀相關記憶檔，不使用工具內建記憶。

**待裁示**
- 需處理 Codex 實際 writable roots 與共用規則記載不一致；目前權限設定無法直接處理 Desktop／Downloads 工作檔。
- 需統一 `CLAUDE.md` 與 `MEMORY.md` 的核決層級文字；依 `MEMORY.md` 最新修正，目前應視「沒有執行副總」為較新的規則，但正本尚未同步。

## 2026-08-04 13:45 ｜ Codex

**做了什麼**
- 完成 Codex 端到端沙箱測試：讀取共用規則正本第一行，並分別在 Desktop 與 Downloads 建立 `_cx_sandbox_test.txt`，讀回內容驗證通過。

**停在哪／下一步／待裁示**
- 測試已完成，無待辦、無待裁示。

## 2026-08-04 ｜ Claude

**做了什麼**
- 把 Claude 與 Codex 的共用度從「只共用記憶檔」補到「規則、能力、交接都共用」：
  - 共用規則正本收斂成本庫 `AGENTS.md` 一份；`~\.codex\AGENTS.md` 與 `Downloads\agent\AGENTS.md` 改成指標檔，不再各自帶條文（原本三份內容不一致，改一份另兩份不會跟）。
  - `~\.codex\config.toml` 的 `writable_roots` 補上 `Desktop` 與 `Downloads`。在此之前 Codex 只寫得到記憶庫，桌面計價本／修改單本／行通表夾／`Downloads\工地` 全部寫不進去，等於接不了請款案。
  - 明令兩邊都不准用工具內建 memory，記憶只走本 repo。
  - 建立本檔 `HANDOFF.md`。

**停在哪**
- 已完成並實測：Codex 從全新程序讀得到共用規則、寫得進桌面與 Downloads。

**下一步／待裁示**
- 承接 `project_billing_batch_state_0803.md`：8 件全審完待裁示，38 題規則沉澱清單在計價本「問題清單」分頁與桌面 `待裁示清單115.08.03.txt`。
- Codex 端沒有 Claude 的 gate-dispatcher 閘門（請款／選股的自動提醒），目前靠 `AGENTS.md` 明文要求代替，效力較弱；若 Codex 實際接手請款後發現漏步驟，再考慮把閘門條文直接寫進共用 `AGENTS.md`。
