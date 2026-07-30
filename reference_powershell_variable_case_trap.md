---
name: reference-powershell-variable-case-trap
description: 🔴PowerShell 變數名不分大小寫，$D 與 $d 是同一個變數——會靜默覆寫陣列造成整批數字錯誤而不報錯；另附回測腳本三個方法論雷(視窗偏誤/前視偏誤/樣本併算)
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7bfe59d6-f454-461e-8d55-a884d957dbc4
  modified: 2026-07-30T09:54:50.658Z
---

## 🔴 事故：`$D` 與 `$d` 是同一個變數
115.07.30 跑崩盤回測時：
```powershell
$D = @($bars | ForEach-Object { $_.D })   # 日期陣列
foreach ($v in $ev) {
  $pi = $D.IndexOf($v[1])                 # 第一圈正常
  $d  = ($bars[$pi+28].A / $pv - 1) * 100 # 🔴 這行把 $D 覆寫成一個 double
}
```
第二圈開始 `$D.IndexOf(...)` 丟 `[System.Double] does not contain a method named 'IndexOf'`，但因為 `$ErrorActionPreference` 不是 Stop、且 `$pi` **保留上一圈的舊值**，`$bars[$pi+28]` 照樣取得到資料 → **跑出一整張數字，全部是錯的，而且看起來很正常**。

當時是靠**常識檢查**抓到的：2024 那次整段才跌 -21.3%，表上卻寫「第 28 天 -75.25%」＝不可能。

**規則**
1. PowerShell 變數名**不分大小寫**，`$D`/`$d`、`$Bars`/`$bars` 都是同一個。回測/掃描腳本一律用**有意義的長名**（`$dates` / `$dayPct`），不要用單字母。
2. 迴圈裡的索引變數每圈開頭**重設**（`$pi = $null`），別讓上一圈的值苟活。
3. 數字跑出來先做一次**量級常識檢查**：單日/區間的百分比有沒有超過該事件本身的總幅度、有沒有超過 ±100%。這條救過這次。
4. 這個雷不限回測——**請款/計價的 Excel 掃描腳本一樣會中**，而且那邊錯了會直接害呈核文件出錯。

## 回測腳本的三個方法論雷（同一天踩到的）
1. **視窗偏誤**：用「事件日後固定 N 根 K 找最低」找底，N 開太大會把**下一次崩盤**當成這次的底（2018-10 的底被算到 2020-03 COVID、2024-08 被算到 2025-04 關稅崩）。正解＝找「事件日 → 第一次收盤站回起跌高點」之間的最低。
2. **手動列事件 vs 正規偵測**：手動列起跌高點會漏事件、也會把兩次獨立事件併成一次（0050 的 2024-08 與 2025-04 是兩次，因為 0050 在 2025-01 創了新高）。正解＝走勢創新高就更新 peak、回檔破門檻才記事件、收復 peak 才結束。n 從 4 變 6。
3. **前視偏誤**：任何用「總跌幅 ÷ 下跌天數」這種**要知道底在哪**才算得出來的指標，都不能拿來當「現在」的預測因子。要驗就改成「只用第 N 天當下可見資訊」重測——這次一測，結論方向直接反過來。

相關 [[feedback_crash_time_to_bottom_0730]]、[[feedback_ps_chinese_literal_encoding]]、[[reference_excel_com_scan_pitfalls]]、[[reference_twse_api_same_day_data]]。
