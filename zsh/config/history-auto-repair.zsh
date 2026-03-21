# =========================
# AUTO REPAIR HISTORY (SMART)
# =========================
[[ -o interactive ]] || return 0

nohup zsh -c '
  LOCK="$HOME/.zsh_history.lock"
  HISTFILE="$HOME/.zsh_history"

  fc -R "$HISTFILE" 2>/dev/null
  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    if mkdir "$LOCK" 2>/dev/null; then
      ~/.config/zsh/history-repair.sh >/dev/null 2>&1
      rmdir "$LOCK"
    fi
  else
    NOW=$(date +%s)
    LAST=$(stat -c %Y "$HISTFILE" 2>/dev/null || echo 0)
    if [ $((NOW - LAST)) -gt 86400 ]; then
      if mkdir "$LOCK" 2>/dev/null; then
        ~/.config/zsh/history-repair.sh >/dev/null 2>&1
        rmdir "$LOCK"
      fi
    fi
  fi
' >/dev/null 2>&1 &!
