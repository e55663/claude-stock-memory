---
name: feedback_stock_completeness_gate
description: "選股跟請款同病根會偷懶漏查(尤其籌碼),已裝每輪強制hook「選股完整性閘門」"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 38f17f18-bf21-4d38-b41b-68f5b5d87cff
---

🔴(2026/7/8 使用者要「我下的指令都是強制的、沒在偷懶」)**選股會跟請款一樣偷懶漏看**,同病根=停在第一個看起來合理的答案就開槍。證據:[[reference_stock_entry_checklist]]自寫「第4關籌碼最常被跳」、[[feedback_flystock_lessons]]籌碼常被我當追價理由。

**根因差別**:請款有每輪UserPromptSubmit hook(completeness-gate.ps1+co-rule-gate.ps1)強制攤查核清單=躲不掉;選股原本只有桌面選股說明.txt(文件)+我的自律=軟的可跳過。

**✅已修**:新增 `C:\Users\Seal_Lo\.claude\hooks\stock-gate.ps1`(每輪Write-Output「🔴選股完整性閘門」),已註冊進settings.json UserPromptSubmit第3條。內容逼我在說某檔『可進/高信心/推薦』前先出:①大盤儀表板②四硬閘門(頂峰剔除/時框/三段分離/籌碼誠實)③進場5題逐檔(集中/防追高/復甦初期/🔴籌碼連買賣/紀律)④🔴每個數字附資料日期;有❌不准說可進。⚠️hook改settings需下個session才生效。

**How to apply**:談股票就當它會跳、照它攤清單;跟請款完整性閘門同規格。改hook文字=更新此記憶。呼應[[feedback_no_perfunctory_work]][[feedback_display_format_circles]]。
