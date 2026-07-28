---
name: feedback_append_row_kills_total_row
description: 追蹤報表加新列時用A欄找最後一列會覆蓋合計列(A欄空白會被End(xlUp)跳過);備註只能填四狀態
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a9b917ec-bef0-41a7-82b6-1a644af1afec
  modified: 2026-07-28T09:32:56.740Z
---

115.07.28 我把 7 件請款 key 進追蹤報表時自己犯的兩個錯，回測抓到才發現。

## 🔴 錯1：用 A 欄 `End(xlUp)` 找最後一列 → 新列直接蓋掉合計列

合計列的 **A 欄(項次)是空白的**，`$ws.Cells.Item($ws.Rows.Count,1).End(-4162).Row` 會跳過它、回傳最後一筆**資料列**的列號。我用 `last+1` 當新列位置，結果新列正好寫在合計列上，把「計 N 件（已歸檔…）」整列覆蓋。141E 請款單的合計列就是這樣被我弄不見的（回測 T6「找不到『計 N 件』合計列」才現形）。

**正確做法**：加列前先**用 C 欄比對 `^計\s*\d+\s*件`** 找出合計列位置，新列插在合計列**之前**（或先記下合計列、寫完再重建）。寫完一定跑 `_追蹤報表回測.ps1`，T6/T6b/T6c/T6d 會驗合計列存在＋件數＝資料列數＋金額＝逐列加總＋四狀態口徑。

## 🔴 錯2：備註欄填了不合法的狀態

`_追蹤報表回測.ps1` L12 寫死 `$合法備註 = @("送出待歸檔","採購議價","退件","已歸檔")`，**或留空白**（＝還沒歸位）。我填了「暫緩」「可送呈」，另一個 session 填了「已送簽核」，全部 FAIL。計價本分頁 tab 標橘＝暫緩是對的，但**追蹤報表備註不能寫暫緩**，該留空白。

## 🔴 錯3（自檢腳本本身）：PowerShell 函式呼叫會把運算子吃進參數

`N($a)*N($b)`、`N($a)+N($b)` 這種寫法，PowerShell 會把後面整串當成第一個函式的參數 → 算出來是垃圾值，害我的自檢誤報兩個 FAIL，差點回頭去改本來就正確的資料。
**寫法**：先落地成變數再運算 —— `$x=N($a); $y=N($b); $r=$x*$y`。

## 🔴 錯4：COM 設 Value2 要顯式 [string]/[double]

`$ws.Range("B$r").Value2 = $x.no`（值來自 hashtable/pscustomobject 屬性）會拋 **"Specified cast is not valid"**。加顯式轉型就好：`= [string]$x.no` / `= [double]$x.amt`。同理 `-f` 格式化出來的字串也要 `[string]$txt`。

**Why**：這四個都不是資料錯，是我工具用錯造成的假結果或真破壞；破壞型的(錯1)不跑回測根本不會發現。
**How to apply**：改共用報表(追蹤報表/計價本總表)後**一定跑回測到 FAIL 0**；回測自己報 FAIL 時，先懷疑是不是我的檢查腳本寫錯，別急著去改本來正確的資料。相關：[[feedback_backtest_discipline]]、[[feedback_verify_after_batch_ops]]、[[reference_excel_com_scan_pitfalls]]
