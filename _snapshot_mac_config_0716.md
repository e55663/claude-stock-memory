# Mac 設定快照（2026/07/16 23:0x）— 給 Windows「比對設定」用

用途：`settings.json` 和 `hooks/` 不在同步 repo 裡，兩台看不到對方。這份是 Mac 的完整快照，
推上 GitHub 後，Windows 開 Claude Code 說「比對設定」時 pull 下來，拿去跟 Windows 本機 diff。
配套計畫見 `project_cross_device_sync_plan_0716`。
⚠️ 這是快照＝寫入當下的狀態，不是即時。之後 Mac 有改要重新產生。

## Mac `~/.claude/settings.json`（全文）
```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "", "hooks": [
        { "type": "command", "command": "git -C ~/.claude/projects/-Users-sungvng-Downloads-CC-agent/memory pull --rebase origin main 2>/dev/null || true" }
      ]}
    ],
    "Stop": [
      { "matcher": "", "hooks": [
        { "type": "command", "command": "cd ~/.claude/projects/-Users-sungvng-Downloads-CC-agent/memory && git add -A && git diff --cached --quiet || git commit -m \"Auto memory sync $(date '+%Y-%m-%d %H:%M')\" && (git push origin main 2>/dev/null || (git pull --rebase origin main && git push origin main)) 2>/dev/null || true" }
      ]}
    ]
  },
  "theme": "dark",
  "model": "opus",
  "permissions": {
    "defaultMode": "bypassPermissions",
    "deny": [
      "Bash(rm -rf /*)","Bash(rm -rf ~*)","Bash(rm -rf .*)","Bash(rm -fr *)","Bash(sudo rm *)",
      "Bash(dd of=/dev/*)","Bash(dd if=* of=/dev/*)","Bash(mkfs*)",
      "Bash(diskutil erase*)","Bash(diskutil reformat*)","Bash(diskutil partitionDisk*)",
      "Bash(git push --force*)","Bash(git push -f *)","Bash(git reset --hard*)",
      "Bash(git clean -fd*)","Bash(git clean -df*)","Bash(chmod -R *)","Bash(chown -R *)",
      "Bash(shutdown *)","Bash(sudo shutdown *)","Bash(reboot*)","Bash(halt*)",
      "Bash(killall *)","Bash(find / -delete*)"
    ]
  },
  "skipDangerousModePermissionPrompt": true
}
```
- statusLine：**未設**（用預設，Mac 沒有自訂狀態列腳本）
- model=opus、theme=dark

## Mac `~/.claude/hooks/`（內容）
- `stock-gate.sh` — 選股完整性閘門，依記憶預填，`chmod +x`、實跑 ExitCode 0。**尚未 wire 進 settings.json**。
- `README_SYNC.md` — 待補清單（completeness-gate / co-rule-gate / statusline）。
- 註：本機沒有 UserPromptSubmit hook 註冊；記憶同步是 settings.json 裡的 inline SessionStart/Stop。

## Windows 那台要做的 diff（逐項核對，缺的補、多的評估）
1. `settings.json` 的 permissions.defaultMode / skipDangerousModePermissionPrompt → 應與 Mac 同（都 bypass）
2. deny 黑名單 → 內容不必一樣（OS 綁死），但**每一條 Mac 有的毀滅級動作，Windows 要有等價的**（rm -rf↔Remove-Item -Recurse -Force /diskutil↔Format-Volume/diskpart 等）
3. theme / model → 應同（dark / opus）
4. hooks：Windows 有的 `stock-gate.ps1` / `completeness-gate.ps1` / `co-rule-gate.ps1` / `statusline-command.ps1` →
   把內容貼出來，Mac 這邊翻成 `.sh` 補齊
5. UserPromptSubmit / statusLine 的 wiring 兩台對齊
6. 決定：要不要把可攜 hook 收進 repo 版控（制度性根治）

## 反向：Windows 開 CC 時請它輸出
在 Windows 說「比對設定」→ 它應 dump：`~/.claude/settings.json` 全文 + `~/.claude/hooks/` 每支 .ps1 內容 + statusLine 設定，
然後跟本快照逐項 diff，把差異兩邊補齊。
