---
name: reference_model_choice_work_vs_chore
description: "🔴請款核對/計價/修改單這種高風險抓錯工作用Opus,雜事(搬檔/跑腳本)用Sonnet;7/20實測Sonnet漏一堆被使用者連環抓"
metadata: 
  node_type: memory
  type: reference
  originSessionId: ab206e15-6560-4b96-b8b5-6d323a3cdbbd
---

🔴(2026/07/20 使用者親身觀察+結論)模型選擇:
- **處理工作(請款核對、計價、修改單、審核抓錯)→用Opus**(目前Opus 4.8)。這類工作「漏一個小地方=害使用者送錯呈核文件」,懲罰很重。
- **雜事(搬檔、改字、跑固定腳本、選股撈資料)→Sonnet就夠**,便宜快。

**為什麼(額度觀察)**:使用者發現今天用Sonnet額度燒很快,以為是Sonnet單價貴。真相=**Sonnet在抓細節任務上出錯多,每次「使用者抓到→我重做→回測」都是額外好幾輪對話,token被乘上去**,不是單價問題。Opus一次做對機率高,對高風險核對工作**總額度反而更省**(省下修正回合)。7/20整天Sonnet漏了:R64整批漏建計價本、行通表沒放資料夾、問題txt沒開、字體沒統一、重複資料夾沒清、扣款memo格式連環錯——全被使用者一項項抓,浪費他大量時間。換Opus後才穩下來。

**How to apply**:使用者這邊工作類請款/計價一律建議用最強模型;他成本敏感,但這是「省時間+避免送錯」的ROI,不是亂花。使用者7/20已把預設切成Opus 4.8。

## 🆕(2026/07/27)對應 Claude 5 世代名單更新
上面「用Opus」的原則不變,但可選名單已換代。現行由強到省:**Fable 5**(claude-fable-5,Mythos級,比Opus高一階,目前最強) > **Opus 5**(claude-opus-5) > **Sonnet 5**(claude-sonnet-5) > **Haiku 4.5**(claude-haiku-4-5-20251001)。
- **請款核對/計價本/修改單/審核抓錯** → Fable 5(大批次、行通表卡關、代扣拆分這種尤其);Opus 5 亦可
- **選股/投資決策** → 同上級別。理由:[[feedback_stock_completeness_gate]]已寫明「選股跟請款同病根會偷懶漏查」(尤其第4關籌碼),真金白銀=跟計價本同級,不是「撈資料的雜事」(這點修正了原文把選股歸在Sonnet那類的寫法)
- **搬檔/跑固定腳本/改字/Gmail整理** → Sonnet 5
- **純機械動作(貼標籤/格式轉換)/雲端routine** → Haiku 4.5
- 切法:一個工作段落換一次即可(`/model claude-fable-5` 開工、收尾雜事再切回),不用每句話換。
