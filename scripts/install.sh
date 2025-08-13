#!/usr/bin/env bash
set -euo pipefail

# Install Git Key Guardian globally by wiring up a shared hooks path

HOOKS_DIR="$HOME/.git-key-guardian/hooks"
mkdir -p "$HOOKS_DIR"

# Copy pre-commit hook
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cp "$REPO_ROOT/hooks/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

# Configure git to use the shared hooks path
if git config --global core.hooksPath >/dev/null 2>&1; then
  CURRENT_PATH=$(git config --global core.hooksPath || true)
  if [ "$CURRENT_PATH" != "$HOOKS_DIR" ]; then
    git config --global core.hooksPath "$HOOKS_DIR"
  fi
else
  git config --global core.hooksPath "$HOOKS_DIR"
fi

# Ensure personal keys file exists
mkdir -p "$HOME/.git-key-guardian"
touch "$HOME/.git-key-guardian/personal_keys.txt"

cat <<'EOS'
✅ Installed Git Key Guardian globally.

Add your personal keys to: $HOME/.git-key-guardian/personal_keys.txt
Update regex patterns in the repo file: patterns/common_patterns.txt

To uninstall, either remove the shared hooks directory or run:
  git config --global --unset core.hooksPath
EOS
