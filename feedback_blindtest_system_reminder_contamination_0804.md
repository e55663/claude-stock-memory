---
name: feedback_blindtest_system_reminder_contamination_0804
description: "🔴Claude/Codex同時跑盲測會互相污染,禁讀清單擋不住——記憶庫被另一程序改動時system-reminder會自動把新內容推進context,不是主動讀取才算污染"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9ccc6e34-d7aa-4deb-bf0c-0625c3a41578
  modified: 2026-08-05T03:14:50.097Z
---

# 0804 模型盲測（Opus vs Sonnet vs Codex 對照試）發現的方法論缺陷

使用者想比較 Opus／Sonnet／Codex 三邊查核同一案子的能力，設計了盲測：複製案夾、拿掉查核記錄.txt（答案卡）、寫禁讀清單提示三邊逐字使用。這個設計本身沒錯，但**執行時發現一個沒預料到的污染管道**。

## 🔴 污染不是靠「主動讀取」才發生

盲測提示裡明寫「以下四處含答案，不准開啟、不准搜尋」。這擋得住 Claude 主動用 Read/Grep 去翻，但擋不住 Claude Code 的機制本身：**當另一個程序（Codex）修改了記憶庫（MEMORY.md／project_*.md）並 commit，正在跑的 Claude session 之後的下一個工具結果會自動帶一段 system-reminder，把改動內容的 diff 推進 context** ——這不是 Claude 選擇要不要讀，是平台行為，Claude 完全無法拒絕接收。

0804 實測：使用者讓 Codex 跑安達#1 查核的同時，Opus 也在跑同一案子的盲測。Codex 寫完結論存進 `project_billing_anda1_codex_compare_0804.md` 並更新 `MEMORY.md` 索引行（含完整答案：132/133命中、115.05.01姓名錯置、24人次跨距不足）。下一個工具呼叫結果回來時，system-reminder 自動附上這段 diff——Opus 當場被污染，盲測作廢。

## How to apply

1. **兩個程序（Claude／Codex）要跑盲測比較時，時間上必須完全錯開**，不能只在提示裡寫禁讀清單就以為安全。一個在跑，另一個要嘛還沒開始要嘛已經完全結束（含 commit/push）。
2. 污染一旦發生要**立刻主動聲明**，不要因為「反正沒去主動讀」就當作沒事——system-reminder 推送的內容一樣算看到答案。
3. 污染發生後不代表這輪測試全部作廢：**污染前已獨立完成的部分仍然有效**，但要清楚切一刀說明「這之前是乾淨的，這之後不算」。
4. 更穩妥的做法（下次要用）：測試期間暫停自動 push/pull hook，或把測試檔案徹底移出記憶庫路徑（如放 Downloads 而非 memory/ 目錄——這點盲測已經做到，但 MEMORY.md 索引行本身仍在記憶庫，一樣會觸發 system-reminder）。

## 對照試最終結果（安達#1 案）

盲測雖然作廢，但 Opus 事後改用「獨立驗證 Codex 宣稱」的方式補救：自己重寫程式重新逐日逐人核對 133 人次，結果與 Codex 報告完全吻合（132/133 命中、24人次跨距不足），證實 Codex 這輪查核可信。詳見 [[project_billing_anda1_codex_compare_0804]]。

## 🔴🔴🔴 0805 追加：污染不只是「暫時」的，寫進 MEMORY.md 索引＝這個案子永久燒掉

0804 記的是**暫時性污染**（兩個程序同時跑才會互相推送），對策是「時間錯開」。0805 實測發現這個理解不夠：

**只要結論被寫進 `MEMORY.md` 的索引行，那個案子就永遠不能再當測試場。** 因為 `MEMORY.md` 是每個 session 開場**強制自動載入**的，不是我選擇要不要讀——新視窗一開,答案就已經在 context 裡了。時間錯開完全擋不住這種。

0805 實例：使用者要跑 Sonnet 5 的對照試，但這個視窗一開場，MEMORY.md 就把安達#1（132/133命中、5/1姓名錯置、24人次跨距不足）和平安#15（少632,772、派工疑重複698、扣墊款63,604）的答案摘要一起載進來了。兩案同時報廢，且**不是這個視窗報廢，是往後任何視窗都報廢**。

**How to apply（覆蓋 0804 的第 4 點）**
1. 選測試案子的判準改成：**答案卡（查核記錄.txt）完整，但 `MEMORY.md` 索引行沒寫出具體發現**。索引行只寫「已審完待裁示」這種沒有內容的，才可以當測試場。
2. 已經在索引行寫出金額差異／姓名錯置／缺件清單的案子，**直接從候選名單剔除**，不要試圖靠提示詞擋。
3. 反過來說：**如果打算把某個案子留作日後測試用，收尾時索引行就不要寫細節**，只寫狀態，細節留在 `project_*.md` 本檔（本檔不會自動載入，禁讀清單擋得住）。
4. 0804 那條「時間錯開」仍然要做，但它只解決兩程序互推，解決不了 MEMORY.md 自動載入。兩層都要顧。

相關：[[feedback_claude_codex_shared_workflow]]（同時開兩邊的風險）、[[feedback_chinese_string_powershell_traps_0804]]（同一測試中另一個自我糾正的雷）、[[reference_model_choice_work_vs_chore]]（對照試已中止、測試場已刪的完整記錄）
