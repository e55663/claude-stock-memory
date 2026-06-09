# 這個 repo 是我的「跨裝置記憶」

這個資料夾同時是 Seal（使用者 e55663@gmail.com）的 Claude Code **跨裝置記憶庫**。
不管你是在手機的 claude.ai/code、還是別台電腦打開這個 repo，請把它當成「記憶」來用。

## 開始工作前，先做這件事
1. **先讀 `MEMORY.md`**——它是記憶索引，每一行對應一個記憶檔。
2. 依使用者這次的問題，挑出相關的記憶檔（例如選股就讀 `stock_selection_logic.md`、`macro_themes.md`、`portfolio_watchlist.md`、`feedback_stock_selection_system.md` 等）後再回答。
3. 記憶檔之間用 `[[檔名]]` 互相連結，可順著追。

## 更新記憶的規則
- 每個記憶檔 = 一個事實，含 frontmatter（`name` / `description` / `metadata.type`）。
- `type` 分四種：`user`(使用者是誰) / `feedback`(他要我怎麼做) / `project`(進行中的事) / `reference`(外部資源)。
- 寫完或改完任何記憶檔，**務必同步更新 `MEMORY.md` 索引那一行**。
- 相對日期要換成絕對日期。
- 改完記得 `git add -A && git commit && git push`，這樣其他裝置才同步得到。

## 重要使用者偏好
- **不要問確認問題**：直接回答、直接動手，不要在執行前問「是否要繼續」這類確認題（見 `feedback_no_clarifying_questions.md`）。
- 使用者主要用途是**台股選股與操作**，相關邏輯散在各 `stock_*`、`macro_*`、`portfolio_*`、`feedback_*`、`winning_strategies.md`、`book_frameworks.md`。
