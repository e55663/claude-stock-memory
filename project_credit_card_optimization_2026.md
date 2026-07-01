---
name: project_credit_card_optimization_2026
description: 信用卡回饋優化系統(PPT+Excel)2026/7更新;Excel已改完PPT待做;官網為準規則+關鍵發現DAWHO Plus無腦王
metadata: 
  node_type: memory
  type: project
  originSessionId: ed1dfbb4-7514-4b32-8bbf-da4234bb3f8c
---

使用者從 `Downloads\信用卡PPT-2022.pptx` 起家、自己多年更新的一套「消費情境→最佳卡」決策系統。2026/7 要求更新到最新。

**🔴資料來源鐵則**：信用卡回饋數字**以銀行官網為準(最準最穩)**,比較網站(Money101/CreditCards/iCard等)只當參考;官網真的讀不到(SPA/404)才用參考並在檔內標「參考」。絕不掰。

**PPT架構(21頁)**:P1-3情境決策矩陣(實體/線上/特殊通路,每格=最佳卡+回饋%+月上限);P4-16,20-21各卡明細(回饋規則+不回饋細則+效期+狀態);P17卡別;P18結帳/繳款日;P19年費。

**✅Excel已完成(2026/7/1)**:改 `Downloads\數字清單.xlsx`(Windows版,非Mac)。①「信用卡」分頁:更新效期(col5)+新增主攻優惠(col6)+資料來源(col11官網/參考)+更新日(col12)+結帳/繳款日(col13/14,來自2022PPT標參考);row2-37依列索引更新(不用中文比對)。②新增「2026情境最佳卡」分頁=17情境矩陣。

**✅PPT已完成(2026/7/1)**:`Downloads\信用卡PPT-2022.pptx`21頁全改。🔴教訓:第一版我把P1-3重建成表格→使用者不滿意「為啥不能跟原本一樣」=要保留他原本手工版面。已從備份還原+改用**只換文字不動版面**(Set-Txt靠shape.Name設TextFrame.TextRange.Text,不刪不加形狀,格子/顏色/位置全保留)。P1-3矩陣格子換卡名/%/上限;P4-16,20-21各卡明細換標題+回饋Rectangle+效期+未更新→已更新;P17卡別/P19年費換死卡名。⚠️結構換卡:花旗PLUS(P4)→星展eco;國泰Costco(P12)→富邦Costco;台新GO/FlyGo(P10,P17,P19)→Richart。COM:$pp.Presentations.Open($path,$false,$false,$false)+$pres.Save()。🟠使用者尚未肉眼確認版面(我無法render),確認後才刪備份。

**2026關鍵發現**:🔴花旗PLUS無腦神卡沒了→新無腦全通路王=**永豐DAWHO大戶Plus**(國內5%/國外6%,上限1000/月;達Plus=財富100萬或綁DAWHO為永豐證券交割戶做1筆台股,使用者有玩台股可解鎖);歐洲(9月法國行)主刷星展eco永續卡5%;影音訂閱遊戲王=玉山UBear數位訂閱10%(上限100)。

**官網已核卡**:星展eco/國泰CUBE/玉山Unicard/玉山UBear/永豐DAWHO/永豐SPORT/第一iLEO/中信LINEPay/中信ALLME/富邦Costco/台新Richart/凱基魔BUY(冷凍)/彰銀my購/星展饗樂。**參考待核**:富邦J/JU/momo、聯邦吉鶴/賴點、國泰蝦皮、合庫i享樂、中信foodpanda/英雄聯盟。

備份 `Downloads\數字清單_備份*.xlsx`、`信用卡PPT-2022_備份*.pptx`(2026/7/1建),PPT做完+使用者確認後刪。相關:[[project_budget_spreadsheet]] [[project_france_trip]] [[feedback_flag_source_errors_vendor_by_invoice]]
