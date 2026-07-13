---
name: project-paris-notion-content
description: "巴黎行程 Notion 頁面已完成 Day1-9 全部填入（2026/07/13）；頁面URL: notion.so/p/seal1018/2026-09-17-ffb2ffc47ce98367ab3201edc329bd26；含 Notion 自動化編輯可靠技巧(剪貼簿貼上法)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 0cccef61-2e07-491f-a7c7-a80f5071c3ab
---

## Notion 頁面狀態（2026/07/13 已完成 ✅）
- 頁面名稱：法國🇫🇷巴黎 2026.09.17
- URL：notion.so/p/seal1018/2026-09-17-ffb2ffc47ce98367ab3201edc329bd26
- ✅ Day1-9 全部改成巴黎內容（含標題+內文），逐一用 innerText 全文比對驗證過，無殘留東京字
- ✅ 每天原本的東京專屬子toggle（訂位/交通細節，通常3-4個）已全部刪除，內容整併進單一 quote block
- ✅ Day10孤立內容其實是Day9自己的子內容（不是獨立段落）、Day11-13 標題連同子內容已整段刪除
- ✅(7/13第二輪)使用者複查後發現「待辦事項/想去的/想吃的/暫存/地區」底下還是東京舊資料，已清乾淨：交通(西瓜卡)、電信(十三天esim)、想去的(新宿原宿澀谷秋葉原等5-6條)、想吃的(燒肉/立食壽司/lawson等6項)、暫存(一整串澀谷/原宿/新宿店家+營業時間,約14個block)、地區四象限(左上角/左下角/右上角/右下角底下新宿/澀谷/淺草/築地/銀座/東京車站/台場等11個地名)。行李分類(個人衣物/裝飾/收納物/電器等)是通用清單不分城市，保留不動。四象限標籤本身(左上角等)也保留當通用結構，只清了裡面的地名內容。
- 男友整理的巴黎資料(景點/百貨/必去/美食)已於7/13全文取得並分類成五清單給使用者核對，內容見 [[project_france_trip]] 或當次對話記錄

🔴 Notion 自動化編輯技巧（這次驗證出來的可靠做法，下次直接用）：
1. **打字/取代文字**：.fill() 和 pressSequentially()（slowly:true）都不可靠，常常看似輸入了但沒存進去或被 React 復原。唯一可靠做法＝**剪貼簿貼上**：`navigator.clipboard.writeText(文字)` (用 browser_evaluate) → 點回該 block 的 contenteditable → `Control+v`。多行用 `\n` 直接寫在字串裡，貼上後會正確變成同一 block 內的換行（quote block 的 CSS 是 white-space:break-spaces）。
2. **清空 block**：點進 contenteditable → `Control+a`（只選該 block 內文字，不會選到整頁）→ `Delete`。
3. **選取後貼上**：Ctrl+A 選取後如果中間插入 `navigator.clipboard.writeText`（async），選取狀態常會掉，貼上會變成「附加在後面」而非取代。保險做法＝先 Ctrl+A+Delete 清空 → 寫剪貼簿 → 重新點回該 block → Ctrl+V。
4. **刪除整個 block**：不要用 Backspace（Notion 的空 toggle 按 Backspace 是「取消縮排」把子內容攤平出來，不是刪除！）。正確做法＝滑鼠 hover 該 block → 找 `[aria-label="Drag to move, click to open menu"]` 按鈕 → click 開選單 → click `text="Delete"`（要用 exact 版本，因為畫面上常有殘留的 "N block deleted" 提示文字會撞到模糊比對）。
5. **hover 找不到 handle**：這個 aria-label 按鈕只在真的滑鼠 hover 到那一行時才會出現在 DOM，且常常第一次 hover 抓不到（React render 時機），要重新 hover 一次再 click。
6. **同一個 data-block-id 常常對到兩個 DOM node**：一個是真實可見的，另一個是 Notion 內部的隱藏測量副本（在畫面外，y 座標可能是負值或超大值）。用 `document.querySelectorAll` 配 `getBoundingClientRect()` 檢查哪個在畫面內，或直接找 `innerText` 不是空字串的那個。
7. **長頁面有 virtualization**：捲到很遠的地方時，畫面外的 block 會從 DOM 卸載，這時用 data-block-id 選取器會找不到元素（或抓到上述隱藏副本）。要先把該區域捲進視窗內（PageDown/PageUp），確認 `getBoundingClientRect` 的 y 值在合理範圍，再操作。
8. 🆕**一次要刪一整串連續 block（比逐個 hover+menu+Delete 快很多）**：點進第一個 block 文字→`Home`→連續按 `Shift+ArrowDown`（每按一次多選一行，會跨過 toggle 標題往下延伸，包括巢狀子內容）→用截圖確認選取範圍涵蓋到最後一個要刪的項目→按一次 `Delete` 整批刪光。比對每個都 hover 找 drag handle 省下 2/3 的步驟。

---

## Day1 - 9/18（五）抵達日

早上
RER B 從 CDG 抵達，飯店寄放行李
聖禮拜堂 Sainte-Chapelle（線上買票 €15，步行5分）
沿塞納河走到 Notre-Dame 外觀

下午
瑪黑區午餐（menu du jour，Rue de Bretagne 附近）
Place des Vosges 逛
15:00 飯店 check-in，休息

晚上（男友到後）
艾菲爾鐵塔 + Trocadéro 廣場
21:00 燈光秀

---

## Day2 - 9/19（六）羅浮宮日

早上
羅浮宮 Musée du Louvre（🔴要提前線上訂時段）

下午
杜樂麗花園午餐
Place Vendôme + Rue Saint-Honoré 逛街（開始累積退稅單）

晚上
瑪黑區散步晚餐

---

## Day3 - 9/20（日）奧賽+蒙馬特

早上
奧賽美術館 Musée d'Orsay（早去避人潮，明天週一休館今天必排）

下午
蒙馬特 + 聖心堂（傍晚光線適合拍照）

晚上
Pigalle 區

---

## Day4 - 9/21（一）西堤島+左岸

早上
聖禮拜堂 + 聖母院外觀（西堤島）

下午
拉丁區 → 盧森堡公園

晚上
Le Bon Marché 百貨

---

## Day5 - 9/22（二）吉維尼一日遊

全天
吉維尼莫內花園 Giverny 一日遊
（4-10月每天開放，羅浮宮/龐畢度今天休館剛好出城）

---

## Day6 - 9/23（三）放空彈性日

早上
奧朗熱麗美術館 Musée de l'Orangerie（莫內睡蓮真跡）

下午
聖傑曼德佩區咖啡 + 書店閒逛
塞納河畔散步

傍晚
Pont des Arts 看夕陽

---

## Day7 - 9/24（四）香檳區一日遊

全天
香檳區一日遊（漢斯 Reims 或埃佩爾奈 Épernay）
酒莊參觀 + 試飲

---

## Day8 - 9/25（五）購物退稅日

白天
Galeries Lafayette + Printemps 百貨
辦退稅（隔天就飛，今天務必完成）
歌劇院區散步，打包行李

晚上
Céline Dion 演唱會 20:00（La Défense Arena，若有票）
或告別晚餐

---

## Day9 - 9/26（六）出發日

早上
計程車去 CDG（建議 07:00 前出門，11:20 起飛）
機場 PABLO 機器辦退稅驗章

---

## 待刪除
Day10-13 → 全部刪除（東京舊行程，巴黎只有 Day1-9）
