---
name: feedback-auto-save-decisions
description: 重要決定/計畫談完，主動幫使用者「落檔」成記憶（.md檔），不用等他每次提醒
metadata:
  node_type: memory
  type: feedback
  originSessionId: current
---

使用者要我：**每次討論到重要決定、計畫、結論時，主動把它濃縮寫成記憶 .md 檔**，不用等他開口要求。

**Why:** 使用者一度以為「對話內容會自動變成記憶、手機 pull 就拿得到」，但其實只有寫成 .md 的記憶才會被 Stop hook 自動 push、被其他裝置同步。對話全文存在本機 session、不會同步。所以重要的事若沒落檔，換裝置就消失。

**How to apply:**
- 重要決定/計畫/結論談完 → 主動濃縮成 .md（重點，非逐字流水帳）+ 更新 MEMORY.md 索引
- Stop hook（[[project-memory-sync-setup]]）會自動 commit+push → 手機 pull 即同步
- 不確定算不算「重要」時傾向落檔；但仍遵守 [[feedback-no-clarifying-questions]]，落檔是主動做、不是先問
- 日常閒聊、過程性討論不用落檔，只存「結論型」內容

## 🔴 115.08.26 例外（他親口）：不要再自動寫進 `選股對帳紀錄.txt`
他當場說「我不要這個 txt 刪掉」→ 已刪 `選股逐檔明細_1150826.txt`，並把本 session 三段從
`Downloadsgent\計價回測工具\選股對帳紀錄.txt` 抽掉（397,110→372,846B，**其他 session 的段落保留**）。
- **往後個股分析不要再自動落到那個 txt**，結論改寫進 `memory/*.md`。
- ⚠️ 這與 UserPromptSubmit hook 的「對帳強制：本次所有建議寫回紀錄檔」衝突。
  **他的口頭指示優先**；要恢復自動寫入需他明講。hook 文字本身要不要改，待他裁示。
- 🔴 那個 txt 不是我專屬：裡面有看盤台自動更新、13:00 追加輪等其他 session 的內容，
  整檔刪除會一起沒有，且 hook 每次「幫我選股」都會讀它 → **不得整檔刪，只能抽自己寫的段**。

