#!/bin/bash
set -euo pipefail

# Only run in remote (web/phone) environment
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR}"

git add -A

if git diff --cached --quiet; then
  # Even if nothing to commit, still sync current branch remote
  current_branch=$(git branch --show-current)
  if [ -n "$current_branch" ] && [ "$current_branch" != "main" ]; then
    git push origin HEAD:"$current_branch" 2>/dev/null || true
  fi
  exit 0
fi

git commit -m "Auto memory sync $(date -u +%Y-%m-%dT%H:%M:%SZ)" --quiet

pushed=0
for i in 1 2 3; do
  if git push origin HEAD:main 2>/dev/null; then
    pushed=1
    break
  fi
  git fetch origin main --quiet
  git merge origin/main --no-edit --quiet || true
done

# Also push to current branch remote to silence platform hook "unpushed commits" warning
current_branch=$(git branch --show-current)
if [ -n "$current_branch" ] && [ "$current_branch" != "main" ]; then
  git push origin HEAD:"$current_branch" 2>/dev/null || true
fi

if [ "$pushed" = "1" ]; then
  echo "Memory auto-pushed to origin/main"
else
  echo "Memory auto-push failed after retries; changes committed locally only"
fi
