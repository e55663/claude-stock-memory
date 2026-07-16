#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
全市場選股掃描 - Mac 版
等同 Windows PowerShell 選股腳本
資料源: TWSE STOCK_DAY_ALL / BWIBBU_ALL / T86(selectType=ALL) + FinMind
"""

import urllib.request, json, sys, datetime, time
from collections import defaultdict

TODAY = datetime.date.today().strftime("%Y%m%d")
FINMIND_BASE = "https://api.finmindtrade.com/api/v4/data"
TWSE_BASE = "https://www.twse.com.tw/rwd/zh"

SKIP_PREFIXES = ('00', '01', '02')  # ETF / 指數 / 特別股略過

def fetch(url, label=""):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=15) as r:
            return json.loads(r.read().decode("utf-8"))
    except Exception as e:
        print(f"[ERR] {label}: {e}", file=sys.stderr)
        return {}

# ── 1. 收盤價 / 漲跌幅 (CSV格式) ─────────────────────────────────────────
def get_price():
    import csv, io
    url = f"{TWSE_BASE}/afterTrading/STOCK_DAY_ALL"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=15) as r:
            raw = r.read().decode("utf-8-sig")
    except Exception as e:
        print(f"[ERR] STOCK_DAY_ALL: {e}", file=sys.stderr)
        return {}
    result = {}
    reader = csv.reader(io.StringIO(raw))
    next(reader, None)  # 跳表頭
    for row in reader:
        if len(row) < 10: continue
        sid = row[1].strip().strip('"')
        if any(sid.startswith(p) for p in SKIP_PREFIXES): continue
        try:
            close = float(row[8].replace(",","").strip('"'))
            spread = float(row[9].replace(",","").strip('"'))  # 漲跌價差
            chg_pct = round(spread / (close - spread) * 100, 2) if (close - spread) != 0 else 0.0
            vol = int(row[3].replace(",","").strip('"'))
            result[sid] = {"name": row[2].strip().strip('"'), "close": close, "chg_pct": chg_pct, "vol": vol}
        except:
            pass
    print(f"[OK] 收盤價 {len(result)} 檔", file=sys.stderr)
    return result

# ── 2. 本益比 / 殖利率 ───────────────────────────────────────────────────
def get_pe():
    d = fetch(f"{TWSE_BASE}/afterTrading/BWIBBU_ALL?response=json", "BWIBBU_ALL")
    result = {}
    for row in d.get("data", []):
        sid = row[0].strip()
        try:
            pe_str = row[2].replace(",","")
            pe = float(pe_str) if pe_str not in ["-","","N/A"] else None
            dy_str = row[3].replace(",","")
            dy = float(dy_str) if dy_str not in ["-","","N/A"] else None
            result[sid] = {"pe": pe, "dy": dy}
        except:
            pass
    print(f"[OK] 本益比 {len(result)} 檔", file=sys.stderr)
    return result

# ── 3. 今日三大法人 ──────────────────────────────────────────────────────
def get_t86(date=TODAY):
    d = fetch(f"{TWSE_BASE}/fund/T86?response=json&date={date}&selectType=ALL", "T86")
    result = {}
    for row in d.get("data", []):
        sid = row[0].strip()
        if any(sid.startswith(p) for p in SKIP_PREFIXES): continue
        try:
            foreign = int(row[4].replace(",",""))   # 外資淨買超(股)
            trust   = int(row[10].replace(",",""))  # 投信淨買超(股)
            dealer  = int(row[13].replace(",",""))  # 自營商淨買超(股)
            result[sid] = {
                "foreign": foreign // 1000,  # 轉張
                "trust":   trust   // 1000,
                "dealer":  dealer  // 1000,
            }
        except:
            pass
    print(f"[OK] T86法人 {len(result)} 檔", file=sys.stderr)
    return result

# ── 4. FinMind 個股法人連續N日買超 ──────────────────────────────────────
def get_finmind_institutional(sid, days=5):
    end = datetime.date.today()
    start = end - datetime.timedelta(days=days*2)
    url = (f"{FINMIND_BASE}?dataset=TaiwanStockInstitutionalInvestorsBuySell"
           f"&data_id={sid}&start_date={start}&end_date={end}&token=")
    d = fetch(url, f"FinMind法人{sid}")
    daily = defaultdict(lambda: {"foreign": 0, "trust": 0})
    for r in d.get("data", []):
        net = r["buy"] - r["sell"]
        if "Foreign_Investor" in r["name"]:
            daily[r["date"]]["foreign"] += net // 1000
        elif "Investment_Trust" in r["name"]:
            daily[r["date"]]["trust"] += net // 1000
    dates = sorted(daily.keys())[-days:]
    foreign_streak = sum(1 for dt in dates if daily[dt]["foreign"] > 0)
    trust_streak   = sum(1 for dt in dates if daily[dt]["trust"] > 0)
    return {"foreign_streak": foreign_streak, "trust_streak": trust_streak, "days": len(dates)}

# ── 5. 主篩選邏輯 ────────────────────────────────────────────────────────
def screen(price, pe, t86):
    candidates = []
    for sid, p in price.items():
        if p["close"] <= 0: continue
        pev = pe.get(sid, {})
        t = t86.get(sid, {"foreign": 0, "trust": 0, "dealer": 0})

        # 過濾條件
        chg = p["chg_pct"]
        foreign = t["foreign"]
        trust   = t["trust"]
        pe_val  = pev.get("pe")
        dy_val  = pev.get("dy")

        # 評分
        score = 0
        flags = []

        # ① 漲幅動能 (≥3.5% 且有量)
        if chg >= 3.5 and p["vol"] >= 500000:
            score += 3
            flags.append(f"動能+{chg:.1f}%")

        # ② 外資今日買超
        if foreign > 500:
            score += 2
            flags.append(f"外資+{foreign:,}張")
        elif foreign < -500:
            score -= 2
            flags.append(f"外資-{abs(foreign):,}張🔴")

        # ③ 投信今日買超
        if trust > 100:
            score += 2
            flags.append(f"投信+{trust:,}張")
        elif trust < -100:
            score -= 1

        # ④ 本益比合理 (5~40倍)
        if pe_val and 5 <= pe_val <= 40:
            score += 1
            flags.append(f"PE{pe_val:.1f}")

        # ⑤ 殖利率 ≥3%
        if dy_val and dy_val >= 3.0:
            score += 1
            flags.append(f"殖{dy_val:.1f}%")

        # ⑥ 跌停/漲停標記
        if chg <= -9.5:
            flags.append("⚠️跌停")
        if chg >= 9.5:
            flags.append("🔥漲停")

        if score >= 3 or (foreign > 2000 and trust > 200):
            candidates.append({
                "sid": sid,
                "name": p["name"],
                "close": p["close"],
                "chg": chg,
                "vol": p["vol"],
                "foreign": foreign,
                "trust": trust,
                "pe": pe_val,
                "dy": dy_val,
                "score": score,
                "flags": " ".join(flags),
            })

    candidates.sort(key=lambda x: x["score"], reverse=True)
    return candidates

# ── 主程式 ───────────────────────────────────────────────────────────────
def main():
    print(f"=== 全市場選股掃描 {datetime.date.today()} ===\n")

    print("抓收盤價...")
    price = get_price()
    print("抓本益比...")
    pe = get_pe()
    print("抓T86法人...")
    t86 = get_t86()

    print("\n篩選中...\n")
    candidates = screen(price, pe, t86)

    print(f"{'代號':<8}{'名稱':<12}{'收盤':>7}{'漲跌%':>7}{'外資張':>8}{'投信張':>7}{'PE':>6}  {'標籤'}")
    print("-" * 80)
    for c in candidates[:30]:
        pe_str = f"{c['pe']:.1f}" if c['pe'] else "-"
        print(f"{c['sid']:<8}{c['name']:<12}{c['close']:>7.1f}{c['chg']:>7.2f}%"
              f"{c['foreign']:>8,}{c['trust']:>7,}{pe_str:>6}  {c['flags']}")

    print(f"\n共 {len(candidates)} 檔進入候選池 (顯示前30)")
    print(f"\n【注意】籌碼連買需用 get_finmind_institutional(sid) 補驗個股多日趨勢")

    return candidates

if __name__ == "__main__":
    main()
