# config/ — 跨裝置本機設定版控

記憶(根目錄那堆 .md)兩台共用同一份;但**本機設定不能共用同一份**——Mac 的 hooks 是 `.sh`、指向 `.sh` 路徑,Windows 是 `.ps1`。所以每個 OS 一個資料夾,各用各的、互相看得到、都進版控。

## 結構
```
config/
  mac/
    settings.json          # Mac 的 ~/.claude/settings.json 備份(autopush 每次關機複製進來;不自動回套)
    statusline-command.sh  # 真檔在這;~/.claude/statusline-command.sh 是 symlink 指過來
    hooks/*.sh             # 真檔在這;~/.claude/hooks/*.sh 是 symlink 指過來
  windows/                 # 待 Windows 那台建立(settings.json + hooks/*.ps1 + statusline-command.ps1)
```

## 同步機制(Mac)
- **hooks + statusline**:真檔放 repo,`~/.claude/` 用 symlink。改檔=改到 repo→關機 autopush 自動 commit+push、開機 autopull 自動更新。**即時雙向同步**。
- **settings.json**:autopush 每次關機 `cp ~/.claude/settings.json → config/mac/`,只做**版控備份**,不自動回套(避免跨 OS 誤套)。要在新機還原就手動 copy 回 `~/.claude/`。

## Windows 那台要做的(將來)
1. `config/windows/` 放 Windows 的 settings.json + hooks/*.ps1 + statusline-command.ps1(真檔),用捷徑/複製對應到 `%USERPROFILE%\.claude\`。
2. autopush.ps1 同樣把 Windows settings.json 備份進 `config/windows/`。
3. 🔴 兩台只有「各自 OS 資料夾」在動,不會互相蓋。改規則邏輯(例如閘門文字)要記得兩邊資料夾一起改。

## 紀律
- 🔴 一次只在一台改設定,關掉(自動 push)再換另一台開(自動 pull),避免衝突。
