---
name: project_mac_device_update
description: 家用Mac(M1 Pro)的系統更新狀態、盜版PD+Windows的歷史卡點、未來VM重建與硬碟清理待辦
metadata: 
  node_type: memory
  type: project
  originSessionId: f9980ab0-1eeb-47da-844e-8a010216527d
---

使用者家裡電腦是 **Mac M1 Pro**(Apple Silicon,公司電腦才是Windows,跟[[project_memory_sync_setup]]提到的Windows同步機是不同台裝置)。

**系統狀態**:這台Mac原本卡在 macOS Ventura 13.5.2(Build 22G91,2023/8發布)放了快3年沒更新。**(2026/06/22)已決定直接跳級更新到 macOS Tahoe 26.5.1**(跳過Sonoma/Sequoia兩個大版本),透過「系統設定→一般→軟體更新」GUI操作觸發(刻意不用終端機指令跑,因為強制重開機會把當下的Claude Code終端機session一起切斷)。使用者**自行決定不做Time Machine備份**就升級(已告知風險:升級失敗開不了機/App不相容/極端情況資料救不回,使用者接受風險直接衝)。

**盜版卡點(暫緩處理)**:使用者的 **Parallels Desktop(PD)跟Windows都是破解/盜版版本**。過去macOS更新曾讓PD+Windows一起壞掉跑不動,根因=破解版PD的修改對應特定舊版macOS虛擬化框架,macOS大版本更新後框架變了、破解配方跟不上→這是使用者長期不敢更新macOS的心理原因。**現在因為使用者已經很少用Windows,VM重建這件事先暫緩、不急**。

**之後若要重啟Windows VM,參考路徑**(已驗證可行):
- 改用 **UTM**(免費開源VM,取代付費+盜版PD,不怕macOS更新後失效)→ 官網 `mac.getutm.app` 下載免費版(⚠️別去Mac App Store,那裡是付費版約US$9.99)
- Windows 11 ARM64 ISO 走**一般下載頁** `microsoft.com/software-download/windows11`,下滑找「下載Windows 11光碟映像檔(ISO)」區塊選 ARM64 multi-edition(⚠️Windows Insider Preview特定網址使用者反應打不開,別用那條路)
- 建VM時選「Virtualize」非「Emulate」(同架構效能好)

**待辦**:使用者說更新Tahoe完成後想叫我做**硬碟清理**(重複檔案/舊下載暫存/不用的App/佔空間大檔),下次他提「清理」可直接接手,刪除前先列清單給他確認再動手。
