---
name: reference-scanned-audit-cost-and-toolchain
description: 掃描件逐張查核的省額度打法(拼圖3-6張/圖+低dpi)與PDF/Office工具鏈現況(poppler v24、markitdown對掃描件無效)
metadata: 
  node_type: memory
  type: reference
  originSessionId: df14850a-5e8c-4fef-add1-40aebda82f28
  modified: 2026-07-30T08:26:15.183Z
---

**背景**：115.07.23 朋洋#8 逐張核 112 張出工單，一張圖一次 Read → **一個 session 的額度直接燒光**。使用者回饋「昨天居然瞬間跑完額度」。但同一位使用者也定調「給我的資料都是要查清楚的」——所以解法不是少查，是改打法。

## 🔴 掃描件查核的省額度打法（115.07.24 起固定）
1. `pdftoppm -png -r 80~90`（不要 110 以上）先轉圖
2. **用 System.Drawing 拼圖**：2×2 或 3×N 併成一張，紅字標 p1/p2…頁碼，一次 Read 看 4~9 張
3. 只有看不清或有疑點的那一張才單獨 `-r 200` 放大重看
4. 拼完立刻刪暫存 png（`Remove-Item -LiteralPath`，不要用 `*` 萬用字元路徑會被安全機制擋）
5. 量大時先跟使用者講一句「這件要看 N 張圖、比較耗額度」，讓他決定現在跑還是排開

實效對照（同樣是「全部查完」）：朋洋 112 張＝額度燒光 vs 正揚 7 張簽單＝**1 張圖**、朋洋施工照片 12 張＝**1 張圖**。

## 工具鏈現況（115.07.23~24 建置）
- **poppler**：`%LOCALAPPDATA%\poppler24\poppler-24.08.0\Library\bin`（已加 User PATH）。🔴 v26.02 版 pdfinfo/pdftoppm 對中文檔案會 Segfault，改用 **v24.08** 才穩；winget 來源在這台是壞的（0x8a15000f），要從 GitHub release 直接抓 zip。
- **Read 工具的 PDF 功能吃不到後加的 PATH** → 自己 `pdftoppm` 轉圖再 Read 圖檔。
  🆕🔴**(115.07.30 實測推翻上一行的做法)Read 工具可以直接吃 PDF**：`Read(file_path=...pdf, pages="1-5")`，掃描件會逐頁以圖片呈現、手寫簽名與印章看得清楚（承洋#4 扣款單3頁、加款單3頁都是這樣讀的，一次一個工具呼叫）。**優先直接 Read PDF，不用再 pdftoppm 轉圖**，省掉整套轉檔＋拼圖＋刪暫存流程。頁數多時仍照上面的省額度原則分批（pages 一次抓一段）。
  ⚠️同日在這台機器 `Get-ChildItem -Recurse` 找 `pdftotext.exe`／`pdftoppm.exe` 都 **0 筆**（含 %LOCALAPPDATA%、C:\ 前三層），poppler 疑似已不在或路徑變了——要用 poppler 前先驗，不要假設還在。
- **Python 3.12.8**（%LOCALAPPDATA%\Programs\Python\Python312）＋ **markitdown[all]** + markitdown-mcp 已裝。
  🔴 實測結論：工地的 PDF 幾乎都是掃描圖，markitdown 抽出來是 **0 位元組**（聖志估驗單、曹新泰簽單皆是）。它只在 **Excel/Word/PPT/文字型PDF** 有用（聖志列控表 xlsx → 11,034 字乾淨表格）。所以它是「省成本工具」不是「抓錯能力工具」，抓錯主戰場（手寫、印章、簽名）仍靠轉圖＋眼睛。
- **Word doc → PDF**：Word COM `ExportAsFixedFormat($path, 17)`，用來看 .doc 施工照片。
- Excel 精準讀寫仍用 COM（markitdown 轉 Markdown 會丟座標與格式）。

相關：[[feedback_read_files_completely]]、[[feedback_session_cost_and_memory_slimming]]
