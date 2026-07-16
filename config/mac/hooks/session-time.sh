#!/bin/bash
# 記錄最後活動時間，供狀態列顯示 📝 — 對應 Windows session-time.ps1
date "+%Y-%m-%d %H:%M" > "$HOME/.claude/last-session-time"
