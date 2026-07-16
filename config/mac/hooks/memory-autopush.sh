#!/bin/bash
# 關 session 時自動 commit+push 記憶 — 對應 Windows memory-autopush.ps1
repo="/Users/sungvng/.claude/projects/-Users-sungvng-Downloads-CC-agent/memory"
[ -d "$repo" ] || exit 0
# 備份 Mac 本機 settings.json 進 repo 版控(hooks/statusline 已 symlink 在 repo 內,不需另存)
cp "$HOME/.claude/settings.json" "$repo/config/mac/settings.json" 2>/dev/null
changes=$(git -C "$repo" status --porcelain)
[ -z "$changes" ] && exit 0
stamp=$(date "+%Y-%m-%d %H:%M")
git -C "$repo" add -A
git -C "$repo" commit -m "Auto memory sync $stamp" >/dev/null 2>&1
GIT_TERMINAL_PROMPT=0 git -C "$repo" push origin HEAD:main >/dev/null 2>&1
if [ $? -ne 0 ]; then
  GIT_TERMINAL_PROMPT=0 git -C "$repo" pull --rebase --autostash origin main >/dev/null 2>&1
  GIT_TERMINAL_PROMPT=0 git -C "$repo" push origin HEAD:main >/dev/null 2>&1
fi
exit 0
