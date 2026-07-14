---
name: Gmail登入通知清理0714
description: Gmail收件匣登入通知歸檔進度與剩餘待辦
metadata:
  type: project
---

# Gmail 登入通知清理（2026-07-14 起）

## 背景
使用者收件匣被 8 家銀行的登入通知灌爆，導致漏看重要信（豐存股 150.02 美元圈存失敗，thread `19f598d2776a95b5`，已保留在收件匣，使用者要去查永豐金證券帳戶餘額）。

## 已完成 ✅
- 建立 Gmail 標籤：`Label_4` = 🔔 登入通知、`Label_5` = 🏦 銀行廣告
- 已歸檔（貼 Label_4 + 移出 INBOX）約 50 封：2026-07-07 ~ 07-14 期間的登入通知
- 已確認：歸檔（跳過收件匣）= 手機不會跳推播，正是使用者要的

## 剩餘待辦 🔴
1. **繼續歸檔約 70 封**（2026 年 5~6 月的舊登入通知）。做法：對每個 message ID 執行 `label_message(Label_4)` + `unlabel_message(INBOX)`。
2. **2 封已貼標籤但還在收件匣**（只需移出 INBOX）：`19f20c0bfbd57b8e`、`19f215276578f1cc`
3. **提醒使用者在 Gmail 網頁版設定篩選器**（未來自動歸檔），8 個寄件者：玉山 sms@mail.esunbank.com、中信 no-reply@email.ctbcbank.com、Richart ebill@richart.com、兆豐 edm@email.megabank.com.tw、凱基 ebanking@kgibank.com、LINE Bank no-reply.ums@linebank.com.tw、DACARD paybill@sinopac.com、華南 notice@hncb.com.tw → 條件加「登入」關鍵字，動作=略過收件匣+貼 🔔 登入通知
4. Bonny & Read 購物金 100 元 **2026-07-16 到期**，提醒使用者用掉

## 待歸檔 message IDs（label Label_4 + unlabel INBOX）
19f2219c2b0794a9(已貼標籤,只差移出INBOX), 19f238278da137ea, 19f1c18a3dbf7d80, 19f1b15417587952, 19f1b107ad7cc244, 19f16de9744d9ac4, 19f16de78ff55613, 19f16d6e925bc6be, 19f17712d21d53fb, 19f1966b404fd25d, 19f0ef74aa886caf, 19f113b79c07271c, 19f123b64d5d86f8, 19f0d0b306a96777, 19f0f07e837518ed, 19f038a86a7efcfc, 19efa37d9ae8aada, 19ef955281862612, 19ef950acd17e94b, 19ef99e475b30bd4, 19eed9568d3e99b1, 19ed07b4904318d5, 19ed07a3d78449a4, 19eb06341b8736a8, 19eb222f795f25d9, 19eabb3e6a039da0, 19eabb02ac8f30c6, 19eabba2b340c897, 19eabd0bc62ccc82, 19ea79ca35570ab1, 19ea1e7ca4e9e203, 19e9b216373c119a, 19e979c390aae51f, 19e983839fc3d7e7, 19e98489a41351a2, 19e984a0b0942d39, 19e9725668f9df0f, 19e9732b120ecf28, 19e983a5d63b78e9, 19e933e54dc53049, 19e93484e3b0d3fb, 19e92bfeb4b16c5a, 19e92c105447b47f, 19e92cd140acd76f, 19e91534bbf13d08, 19e934969ffcc1fe, 19e7d54ede5c9751, 19e7d55283387f80, 19e7d5264a80eed4, 19e79caa9d66156c, 19e79ce8c75f7058, 19e6f5d3e2c7c6be, 19e6a538fd2088b2, 19e625a19c0b2ed7, 19e5e457f7d88adf, 19e5e4aac6c628c0, 19e5ef32387faa13, 19e532c03a1c332a, 19e532a86e49fcc6, 19e505e63d537a15, 19e493984958683f, 19e49381d529aeed, 19e39eac537248b2, 19e35d9b9756420b, 19e36701fdf6ccfc, 19e2aff8568a01ce, 19e2afe950786dfa, 19e2bbb702e64bd0

## 🔴 權限教訓（下個 Session 必讀）
- 雲端 claude.ai/code 的 Gmail MCP 每次呼叫都會跳授權視窗——**使用者第一次看到時要點「永遠允許（Always allow）」**，之後整個 Session 不再問。
- 本機 `~/.claude/settings.json` 的 `bypassPermissions` **管不到雲端 Session**（使用者已在本機設好，只對本機 Claude Code 生效）。
- 使用者明確說過：「我不要再給我確認了…只是移資料沒有要刪資料」——歸檔操作直接批次執行，不要逐一問。
- 保留不動：圈存失敗 thread `19f598d2776a95b5`、DAWHO 轉帳紀錄、信用卡繳費紀錄。

相關：[[feedback_no_clarifying_questions]]、[[feedback_permission_tiers]]
