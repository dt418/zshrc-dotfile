#!/usr/bin/env zsh

set -euo pipefail

if [[ "${1:-}" == "alias" ]]; then
  source "$HOME/.config/zsh/aliases.zsh"
  alias "${2:?alias name required}" >/dev/null
  echo "ok: alias ${2}"
  exit 0
fi

source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

assert_alias() {
  local name="$1"
  alias "$name" >/dev/null || { echo "FAIL: alias $name missing"; exit 1; }
}

assert_function() {
  local name="$1"
  typeset -f "$name" >/dev/null || { echo "FAIL: function $name missing"; exit 1; }
}

assert_alias ls
assert_alias lg
assert_alias dc

assert_function fsearch
assert_function dklog
assert_function log

echo "All tests passed"
