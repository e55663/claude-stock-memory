---
name: reference-ig-follower-compare
description: IG匯出比對『誰沒回追我』的做法+最大坑:粉絲清單匯出一定要選『所有時間』否則被時間砍到灌水
metadata: 
  node_type: memory
  type: reference
  originSessionId: 97289b33-e691-41f2-98f4-88b03715990c
  modified: 2026-07-24T09:45:08.947Z
---

用 Instagram 官方資料匯出比對「我追蹤但對方沒回追我」的做法與唯一大坑。

**🔴最大坑=匯出的日期範圍**：IG 匯出「追蹤者和粉絲」時,**粉絲(followers)清單會被日期範圍過濾**(照對方「按下追蹤你的日期」濾),但**追蹤(following)清單永遠給完整版**。所以選了區間 → 粉絲名單只剩那段期間新追你的人,追蹤名單卻是全的 → 比對出「沒回追」暴量灌水。
- 115.07.24 實測(使用者seal1018,粉絲實際~1.2萬):選1年→粉絲只撈到3,804、選1週→只撈到1個、選「所有時間」→12,218(對)。following 每次都是614(2013~2026完整,不受影響)。
- 正確設定:下載你的資訊 → 選帳號 → 選「追蹤者和粉絲」→ **日期範圍=所有時間 / All time** → HTML格式。
- 判斷檔案完不完整:看 followers_1.html 表頭「包括你要求的資料(X 至 Y)」,有區間宣告=被砍;粉絲多會分頁(followers_1滿10,000筆→followers_2...),要全部合併算。

**檔案結構/解析**：解壓後在 `connections\followers_and_following\`。
- following.html 的連結格式是 `instagram.com/_u/用戶名`,followers_1.html 是 `instagram.com/用戶名`(**兩種格式不同**),regex 要 `href="https://www\.instagram\.com/(?:_u/)?([^"?/]+)"` 兩者都吃。
- pending_follow_requests / recently_unfollowed 用的是表格格式(`用戶名稱</td><td>...`)不是連結。
- 比對用小寫去重(ToLower)。「沒回追」= following 有、followers 沒有。
- following 是「當下」清單,退追的人不會留在裡面(退追清單與 following 交集=0 驗過),所以自己來回追蹤不會灌水;灌水只會來自粉絲被時間砍。

**結果Excel**:直接建桌面 `IG未回追清單_YYYYMMDD.xlsx`(序號/帳號/可點連結),此為生活雜事、非工作檔。
COM雷:Value2 對數字要 `[double]`、字串要 `[string]`,per-cell寫,別用2D陣列丟Value2(此環境會 InvalidCast)。相關 [[project_budget_spreadsheet]]。
