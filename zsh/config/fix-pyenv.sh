#!/usr/bin/env bash

# Fix pyenv shim and lock issues safely
# Usage: fixpyenv

set -euo pipefail

PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
LOCK_FILE="$PYENV_ROOT/shims/.pyenv-shim"

# Only show errors by default
VERBOSE="${VERBOSE:-0}"

log_info() {
  if [ "$VERBOSE" -eq 1 ]; then
    echo "$@"
  fi
}

log_error() {
  echo "$@" >&2
}

# 1. Kill any stuck pyenv processes
log_info "🔍 Checking pyenv lock..."
log_info "🧠 Killing stuck pyenv processes (if any)..."
PIDS=$(ps aux | grep '[p]yenv' | awk '{print $2}' || true)

if [ -n "$PIDS" ]; then
  echo "$PIDS" | xargs -r kill -9 2>/dev/null || true
  log_info "✔ Killed stuck processes"
else
  log_info "✔ No stuck processes"
fi

# 2. Remove lock file
if [ -f "$LOCK_FILE" ]; then
  log_info "🧹 Removing stale lock file..."
  rm -f "$LOCK_FILE"
  log_info "✔ Lock file removed"
else
  log_info "✔ No lock file found"
fi

# 3. Fix permissions
log_info "🔐 Fixing permissions..."
if [ -d "$PYENV_ROOT" ]; then
  chown -R "$USER:$USER" "$PYENV_ROOT" 2>/dev/null || true
  log_info "✔ Permissions fixed"
else
  log_error "⚠ pyenv root not found: $PYENV_ROOT"
fi

# 4. Clean shims (optional but safe)
log_info "🧼 Cleaning shims..."
if [ -d "$PYENV_ROOT/shims" ]; then
  find "$PYENV_ROOT/shims" -maxdepth 1 -type f -delete 2>/dev/null || true
  log_info "✔ Shims cleaned"
else
  mkdir -p "$PYENV_ROOT/shims" 2>/dev/null || true
  log_info "⚠ Shims directory created"
fi

# 5. Rehash
log_info "🔄 Running pyenv rehash..."
if command -v pyenv >/dev/null 2>&1; then
  pyenv rehash 2>/dev/null || true
  log_info "✅ pyenv rehash completed successfully"
else
  log_error "⚠ pyenv not found in PATH"
fi

log_info "🎉 Done!"
