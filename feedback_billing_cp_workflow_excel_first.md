---
name: feedback_billing_cp_workflow_excel_first
description: "🔴高CP請款處理流程(使用者115.07.27定):數字一律走Excel(列控/計算式/彙總,快準省),掃描件只在Excel沒有的資訊(簽名/發票/報價單特徵)才看且不靠眼睛手加;分階段=先前置全部歸夾→再一案一案獨立審核出查核清單"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e0ecc4d-2dee-4fc7-99db-a768616a42a7
  modified: 2026-07-27T03:27:25.342Z
---

🔴 **使用者115.07.27定調(一次丟9案後)**：他要的理想＝「丟資料→我一次處理好→額度花很少→答案清晰明瞭」。他的痛點＝實際上我花很多時間、還不一定對、他還要一個個問我問題在哪。要我把最高CP值的做法定下來、寫進記憶＋打法說明。

**病灶分析（呂發#7 案得出）**：貴又不一定對，幾乎只發生在**掃描件**。呂發37張扣款是掃描PDF、又沒有Excel彙總，我被迫逐張看圖(燒4次大讀取)+手加37個模糊數字(可能加錯=違反絕不掰)。反觀請款金額5,753,460是從**列控表.xlsx**秒對、又準又省。

**How to apply（高CP流程，之後請款/計價一律照此）**：
1. 🔴 **數字一律走 Excel**：列控表/計算式/(KG小包計價)彙總表這些 xlsx 用 COM 讀，機器可讀、快、準、省額度。金額、數量、單價、扣款總額**優先從 Excel 取**，不從掃描件眼加。
2. 🔴 **掃描件(PDF/JPG)只在「Excel 沒有的資訊」才讀**：簽名有無、發票號、報價單是否根基版本、施工照片。且照 [[reference_scanned_audit_cost_and_toolchain]] 省額度打法(拼圖/批次)，**只驗總額與抽樣，不逐張眼睛加總**。
3. 🔴 **扣款額**：先要「扣款彙總 / KG小包計價彙總表(Excel)」；有彙總就用彙總算總額、掃描件只當簽名佐證。**沒有彙總才被迫逐張讀**——這種案子要主動跟使用者講「這案沒有Excel彙總，扣款只能逐張掃描加總、較貴且我手加需你複核」，讓他決定是否去系統匯出彙總。
4. **分階段(使用者流程)**：①他先把大量檔案丟進來→我做「前置作業」＝全部安全歸夾([[feedback_never_mix_bash_powershell_file_ops]]純PowerShell法)，不逐案深讀。②再一案一案獨立審核，每案輸出完整查核清單(每項✅已查+出處/❌未查)給他看，他會逐案問「這個如何」(他在再三確認資料有無問題)。③動計價本/串聯留到他該案確認後。
5. 🔴 **前置歸夾用安全法**：New-Item建夾→Test-Path -PathType Container→逐檔Move-Item -LiteralPath+驗落夾內+根目錄無；共用主檔(零星列控表工地端、KG加扣款記錄單跨多案)用複製不搬走藏起來。

相關：[[feedback_stage_in_downloads_before_archive]]、[[feedback_never_mix_bash_powershell_file_ops]]、[[reference_scanned_audit_cost_and_toolchain]]、[[feedback_hangtong_existence_gate]]
