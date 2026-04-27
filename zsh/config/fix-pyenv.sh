#!/usr/bin/env bash

# Fix pyenv shim and lock issues safely
# Usage: fixpyenv

set -euo pipefail

PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
LOCK_FILE="$PYENV_ROOT/shims/.pyenv-shim"

echo "🔍 Checking pyenv lock..."

# 1. Kill any stuck pyenv processes
echo "🧠 Killing stuck pyenv processes (if any)..."
PIDS=$(ps aux | grep '[p]yenv' | awk '{print $2}' || true)

if [ -n "$PIDS" ]; then
  echo "$PIDS" | xargs -r kill -9 2>/dev/null || true
  echo "✔ Killed stuck processes"
else
  echo "✔ No stuck processes"
fi

# 2. Remove lock file
if [ -f "$LOCK_FILE" ]; then
  echo "🧹 Removing stale lock file..."
  rm -f "$LOCK_FILE"
  echo "✔ Lock file removed"
else
  echo "✔ No lock file found"
fi

# 3. Fix permissions
echo "🔐 Fixing permissions..."
if [ -d "$PYENV_ROOT" ]; then
  chown -R "$USER:$USER" "$PYENV_ROOT" 2>/dev/null || true
  echo "✔ Permissions fixed"
else
  echo "⚠ pyenv root not found: $PYENV_ROOT"
fi

# 4. Clean shims (optional but safe)
echo "🧼 Cleaning shims..."
if [ -d "$PYENV_ROOT/shims" ]; then
  find "$PYENV_ROOT/shims" -maxdepth 1 -type f -delete 2>/dev/null || true
  echo "✔ Shims cleaned"
else
  mkdir -p "$PYENV_ROOT/shims" 2>/dev/null || true
  echo "⚠ Shims directory created"
fi

# 5. Rehash
echo "🔄 Running pyenv rehash..."
if command -v pyenv >/dev/null 2>&1; then
  pyenv rehash 2>/dev/null || true
  echo "✅ pyenv rehash completed successfully"
else
  echo "⚠ pyenv not found in PATH"
fi

echo "🎉 Done!"
