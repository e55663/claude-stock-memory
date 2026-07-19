#!/bin/bash
set -euo pipefail

# Only run in remote (web/phone) environment
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR}"

# Pull latest memory files from main using rebase to avoid merge commit buildup
git fetch origin main
git rebase origin/main --autostash 2>/dev/null || \
  git merge origin/main --no-edit 2>/dev/null || true

# Sync current branch remote so platform hook sees 0 unpushed commits
current_branch=$(git branch --show-current)
if [ -n "$current_branch" ] && [ "$current_branch" != "main" ]; then
  git push origin HEAD:"$current_branch" 2>/dev/null || true
fi

echo "Memory synced from origin/main"
