#!/bin/bash
set -euo pipefail

# Only run in remote (web/phone) environment
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR}"

# Pull latest memory files from main
git fetch origin main
git merge origin/main --no-edit --allow-unrelated-histories 2>/dev/null || \
  git merge origin/main --no-edit 2>/dev/null || true

echo "Memory synced from origin/main"
