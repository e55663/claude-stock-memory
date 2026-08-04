---
name: feedback-claude-codex-shared-workflow
description: Claude Code 與 Codex 共用工作區、記憶與驗證迴圈；任何工作都要測到正確才算完成
metadata:
  node_type: memory
  type: feedback
  originSessionId: codex-setup-2026-08-04
---

# Claude Code 與 Codex 共用工作方式

2026-08-04 使用者決定增加 Codex 作為 Claude Code 額度不足時的接手工具。兩邊不是各自獨立，而是共用同一套工作資料、個人偏好、記憶索引與重要結論，目標是降低重講背景與重做工作的成本。

## 共用架構

- 共用工作資料夾：`C:\Users\Seal_Lo\Downloads\agent`
- 共用記憶庫：本 repository
- Claude 啟動指令：`cc`
- Codex 啟動指令：`cx`
- `cx` 開場自動 pull 記憶，離開時自動 commit/push 有變更的記憶。
- 同一時間不要讓 Claude 與 Codex 修改同一個檔案；換手前先讓前一邊完成寫檔與同步。

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

相關：[[feedback-evidence-required-no-assumptions]]、[[feedback-backtest-discipline]]、[[feedback-read-files-completely]]、[[feedback-no-perfunctory-work]]
