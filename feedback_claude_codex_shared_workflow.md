---
name: feedback-claude-codex-shared-workflow
description: Claude Code 與 Codex 共用工作區、記憶與驗證迴圈；任何工作都要測到正確才算完成
metadata:
  node_type: memory
  type: feedback
  originSessionId: codex-setup-2026-08-04
  modified: 2026-08-04T05:47:40.334Z
---

# Claude Code 與 Codex 共用工作方式

2026-08-04 使用者決定增加 Codex 作為 Claude Code 額度不足時的接手工具。兩邊不是各自獨立，而是共用同一套工作資料、個人偏好、記憶索引與重要結論，目標是降低重講背景與重做工作的成本。

## 共用架構（2026-08-04 下午補齊四個缺口後）

- 共用工作資料夾：`C:\Users\Seal_Lo\Downloads\agent`
- 共用記憶庫：本 repository
- Claude 啟動指令：`cc`；Codex 啟動指令：`cx`
- `cx` 開場自動 pull 記憶，離開時自動 commit/push 有變更的記憶。
- 同一時間不要讓 Claude 與 Codex 修改同一個檔案；換手前先讓前一邊完成寫檔與同步。

### 四層共用（只共用記憶是不夠的）

1. **規則正本單一化**：共用規則正本＝本庫 `AGENTS.md`；業務規則正本＝`C:\Users\Seal_Lo\CLAUDE.md`。`~\.codex\AGENTS.md` 與 `Downloads\agent\AGENTS.md` 已改成純指標檔。原本三份 AGENTS.md 各帶不同條文（992／1286／1822 bytes），改一份另兩份不會跟＝規則漂移。
2. **能力對等**：`~\.codex\config.toml` 的 `writable_roots` 原本只有記憶庫，Codex 寫不進 `Desktop`（計價本／修改單本／行通表夾／追蹤報表）與 `Downloads`（工地歸檔／個人／公司），等於接不了請款案。已補上這兩個 root。
3. **記憶不分岔**：兩邊都禁用工具內建 memory（Codex 的 `memories_1.sqlite` Claude 讀不到）。要保存的一律寫本庫 `.md` ＋更新 `MEMORY.md`。
4. **交接**：本庫 `HANDOFF.md`，收工前在最上面補一段（日期／哪一邊／做了什麼／停在哪／下一步／待裁示），接手方開場先讀最新一段。

### 已知未補的差異

- Codex 沒有 Claude 的 `gate-dispatcher` 閘門（請款／選股的自動提醒 hook），目前靠 `AGENTS.md` 明文要求代替，效力較弱。若 Codex 接手請款後實際漏步驟，再把閘門條文直接寫進共用 `AGENTS.md`。
- Claude session 進行到一半不會重新 pull；同一台機器共用同一份實體檔案所以無影響，跨裝置（Mac）換手才需要重開 session。

## 最高位階驗證規則

使用者明確要求：「要有回測的功能，就是要回去測到作對為止。」

- 做完或指令成功不等於正確；必須讀回實際輸出、跑測試、回測或逐項核對。
- 發現失敗或不符預期時，直接修正並重新執行，不要停在第一次失敗，也不要把問題丟回使用者。
- 只有全部驗證通過，或確認存在無法由本機解決的外部阻礙，才能結束並回報。
- 不得製造假 PASS：測試腳本本身也要先做合理性與資料完整性檢查。
- 股票與策略驗證必須使用當次相同股票池、時間窗、條件與市場情境；其他樣本的結果只能當參考，不能直接宣稱本次有效。

## 2026-08-04 Codex 啟動設定驗證事故

第一次設定 `cx` 後，只檢查 PowerShell 函式內容、Codex 版本與 Git 同步，就直接回報「可以使用」；使用者實際測試失敗後指出沒有真正回測。這不符合本檔的驗證規則。

往後啟動器、hook、同步或環境設定的完成標準不是「設定檔看起來正確」，而是至少：

1. 從全新的終端程序載入設定。
2. 經由真正的入口指令執行版本檢查。
3. 經由同一入口執行最小端到端任務，確認工作目錄、模型連線、sandbox、approval、網路與額外寫入路徑均為預期。
4. 實際回讀輸出與退出碼；全部正確才可回報完成。

本次修正後實測：`cx --version` 成功回傳 `codex-cli 0.146.0`；`cx exec --skip-git-repo-check '只輸出 CX_E2E_OK'` 成功在 `C:\Users\Seal_Lo\Downloads\agent` 執行並回傳 `CX_E2E_OK`。

## 2026-08-04 13:46 四層共用回測（全 PASS）

從全新 PowerShell 程序走 `cx` 入口跑 `cx exec`，實測結果：

- sandbox 標頭確認 writable roots＝`workdir, /tmp, $TMPDIR, memory庫, C:\Users\Seal_Lo\Desktop, C:\Users\Seal_Lo\Downloads`，model `gpt-5.6-sol`，approval `never`。
- Codex 未經提示即自行執行「開工必讀順序」，一次讀完 `AGENTS.md`＋`CLAUDE.md`＋`MEMORY.md`＋`HANDOFF.md`，並逐字回讀共用規則正本第一行。
- 實際寫入 `Desktop\_cx_sandbox_test.txt`＝`CX_DESKTOP_OK`、`Downloads\_cx_sandbox_test.txt`＝`CX_DOWNLOADS_OK`，Claude 端讀回確認後刪除。
- Codex 主動在 `HANDOFF.md` 補寫自己的交接段＝交接機制自動生效。
- 退出碼 0，離開時自動 push 成功（`a2b8b96..1389f59`）。

🔴 測試腳本雷：中文 here-string 寫進 `.ps1`（無 BOM）會被 PS 5.1 當 ANSI 讀而噴 `The string is missing the terminator`；傳給 codex.exe 的 prompt 一律用純 ASCII，中文另存檔讀入。見 [[feedback-ps-chinese-literal-encoding]]。

相關：[[feedback-evidence-required-no-assumptions]]、[[feedback-backtest-discipline]]、[[feedback-read-files-completely]]、[[feedback-no-perfunctory-work]]
