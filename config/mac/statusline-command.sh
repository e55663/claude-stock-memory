#!/bin/bash
# 狀態列（Mac 版，對應 Windows statusline-command.ps1，重建為可執行 bash）
# 兩行：①🚀✨ 模型 / context bar / 5h,7d 額度  ②git 分支+diff+專案 / 📝最後活動
# 需要 jq；額度/context 欄位在 Claude Code 沒提供時自動略過（graceful）。
command -v jq >/dev/null 2>&1 || { echo "🚀✨ (statusline 需 jq：brew install jq)"; exit 0; }

input=$(cat)

# 主題色
_THEME=$(jq -r '.theme // empty' "$HOME/.claude/settings.json" 2>/dev/null)
[ -z "$_THEME" ] && _THEME="dark"
if [[ "$_THEME" == *light* ]]; then
  WH=$'\033[38;2;40;40;40m'; GR=$'\033[38;2;20;120;20m'; YL=$'\033[38;2;160;100;0m'
  OG=$'\033[38;2;180;80;0m'; RD=$'\033[38;2;180;40;40m'; DM=$'\033[38;2;110;110;110m'
else
  WH=$'\033[97m'; GR=$'\033[38;2;80;200;81m'; YL=$'\033[38;2;246;184;90m'
  OG=$'\033[38;2;255;152;0m'; RD=$'\033[38;2;244;67;54m'; DM=$'\033[90m'
fi
RS=$'\033[0m'
SEP="${DM} │ ${RS}"

model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
remaining=$(printf '%s' "$input" | jq -r '(.context.remaining_percentage // .context.remaining // empty)')
rl5=$(printf '%s'  "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl5r=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl7=$(printf '%s'  "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rl7r=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

_ttl() {
  local target="$1" now s d h m
  now=$(date +%s)
  case "$target" in
    ''|*[!0-9]*) return ;;               # 非純數字(epoch)就不顯示 TTL
    *) s=$(( target - now )) ;;
  esac
  [ "$s" -le 0 ] && { printf '0m'; return; }
  d=$((s/86400)); h=$(((s%86400)/3600)); m=$(((s%3600)/60))
  if   [ $d -gt 0 ]; then printf '%sd%sh' "$d" "$h"
  elif [ $h -gt 0 ]; then printf '%sh%sm' "$h" "$m"
  else printf '%sm' "$m"; fi
}
_rlcolor() {
  local r=$1
  if   [ "$r" -gt 75 ]; then printf '%s' "$GR"
  elif [ "$r" -gt 50 ]; then printf '%s' "$YL"
  elif [ "$r" -gt 25 ]; then printf '%s' "$OG"
  else printf '%s' "$RD"; fi
}

# ---- 第一行 ----
L1="🚀✨"
[ -n "$model" ] && L1="${L1} ${WH}${model}${RS}"

if [ -n "$remaining" ]; then
  BAR_W=10
  used=$(awk -v r="$remaining" 'BEGIN{u=100-r; if(u<0)u=0; if(u>100)u=100; printf "%d",u}')
  filled=$(( used * BAR_W / 100 ))
  z1=$(( BAR_W/4 )); z2=$(( BAR_W/2 )); z3=$(( BAR_W*3/4 ))
  bar=""
  for ((n=0; n<BAR_W; n++)); do
    if [ $n -lt $filled ]; then
      if   [ $n -lt $z1 ]; then bar="${bar}${GR}█"
      elif [ $n -lt $z2 ]; then bar="${bar}${YL}█"
      elif [ $n -lt $z3 ]; then bar="${bar}${OG}█"
      else                      bar="${bar}${RD}█"; fi
    else bar="${bar}${DM}░"; fi
  done
  bar="${bar}${RS}"
  [ "$used" -gt 80 ] && pc=$RD || pc=$WH
  L1="${L1}${SEP}${bar} ${pc}${used}%${RS}"
fi

if [ -n "$rl5" ]; then
  r=$(awk -v u="$rl5" 'BEGIN{v=100-u; if(v<0)v=0; printf "%d",v}')
  t=""; [ -n "$rl5r" ] && { tt=$(_ttl "$rl5r"); [ -n "$tt" ] && t=" ${DM}(${tt})${RS}"; }
  c=$(_rlcolor "$r"); L1="${L1}${SEP}${WH}5h:${RS}${c}${r}%${RS}${t}"
fi
if [ -n "$rl7" ]; then
  r=$(awk -v u="$rl7" 'BEGIN{v=100-u; if(v<0)v=0; printf "%d",v}')
  t=""; [ -n "$rl7r" ] && { tt=$(_ttl "$rl7r"); [ -n "$tt" ] && t=" ${DM}(${tt})${RS}"; }
  c=$(_rlcolor "$r"); L1="${L1}${SEP}${WH}7d:${RS}${c}${r}%${RS}${t}"
fi

# ---- 第二行 ----
L2=""
if git_top=$(git rev-parse --show-toplevel 2>/dev/null); then
  br=$(git branch --show-current 2>/dev/null)
  if [ -n "$br" ]; then
    dirty=""; git diff-index --quiet HEAD -- 2>/dev/null || dirty="*"
    L2="${WH}${br}${dirty}${RS}"
  fi
  stat=$(git diff --shortstat HEAD 2>/dev/null)
  ins=$(printf '%s' "$stat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
  del=$(printf '%s' "$stat" | grep -oE '[0-9]+ deletion'  | grep -oE '[0-9]+')
  if [ -n "$ins" ] || [ -n "$del" ]; then
    ds=""; [ -n "$ins" ] && ds="${GR}+${ins}${RS}"; [ -n "$del" ] && ds="${ds}${RD}-${del}${RS}"
    [ -n "$L2" ] && L2="${L2}${SEP}${ds}" || L2="$ds"
  fi
  pname=$(basename "$git_top")
  if [ -n "$pname" ]; then
    [ -n "$L2" ] && L2="${L2}${SEP}${WH}${pname}${RS}" || L2="${WH}${pname}${RS}"
  fi
fi
if [ -f "$HOME/.claude/last-session-time" ]; then
  lm=$(cat "$HOME/.claude/last-session-time" 2>/dev/null)
  if [ -n "$lm" ]; then
    [ -n "$L2" ] && L2="${L2}${SEP}${DM}📝 ${lm}${RS}" || L2="${DM}📝 ${lm}${RS}"
  fi
fi

printf '%s\n' "$L1"
[ -n "$L2" ] && printf '%s\n' "$L2"
