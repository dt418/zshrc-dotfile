#!/usr/bin/env bash

HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
TMP="$HISTFILE.tmp"
CLEAN="$HISTFILE.clean"
BACKUP="$HISTFILE.bak"

# =========================
# QUICK CHECK (fast path)
# =========================
# Nếu file đọc OK → skip luôn
fc -R "$HISTFILE" 2>/dev/null
if [ $? -eq 0 ]; then
  exit 0
fi

echo "[zsh-history] corruption detected → repairing..." >&2

# =========================
# BACKUP
# =========================
cp "$HISTFILE" "$BACKUP" 2>/dev/null

# =========================
# REPAIR
# =========================
strings "$BACKUP" > "$TMP" 2>/dev/null

# dedupe nhưng giữ thứ tự mới nhất
awk '!seen[$0]++' "$TMP" > "$CLEAN"

mv "$CLEAN" "$HISTFILE"
rm -f "$TMP"

echo "[zsh-history] repaired" >&2
