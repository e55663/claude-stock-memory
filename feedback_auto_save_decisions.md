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
