---
name: feedback-display-format-circles
description: 選股輸出用emoji圓圈取代顏色標示，壓縮文字量，視覺快速定位
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 41b67d60-e1d6-4122-93a0-7eb7987b158d
---

選股/回報輸出固定用四色圓圈標記，大幅壓縮推理文字、只留結論：

🔴 風險 / 警示 / 不進場
🟢 可進場 / 結論推薦
🟡 觀察中 / 條件未滿足
⚫ 該區塊最終結論（每個區塊結尾必出一行）

**Why:** 使用者反映字太多難看，真實顏色在此介面不支援，圓圈是最有效的視覺替代。

**How to apply:** 每次選股九區塊輸出，每個區塊開頭/結尾都要有圓圈標記；推理過程壓短，結論一行講完。
