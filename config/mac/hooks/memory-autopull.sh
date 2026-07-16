#!/bin/bash
# 開 session 時自動拉記憶 — 對應 Windows memory-autopull.ps1
repo="/Users/sungvng/.claude/projects/-Users-sungvng-Downloads-CC-agent/memory"
[ -d "$repo" ] || exit 0
GIT_TERMINAL_PROMPT=0 git -C "$repo" pull --rebase --autostash origin main 2>&1
exit 0
