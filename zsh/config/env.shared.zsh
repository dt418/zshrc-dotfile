# =========================
# SHARED ENVIRONMENT
# =========================

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# nvm — lazy load để tránh làm chậm startup
_load_nvm() {
  for cmd in nvm node npm npx; do
    (( ${+functions[$cmd]} )) && unset -f "$cmd"
  done

  local nvm_dir="${NVM_DIR:-}"
  if [[ -z "$nvm_dir" ]]; then
    for dir in "$HOME/.nvm" "$HOME/.local/share/nvm" "$HOME/nvm"; do
      if [[ -s "$dir/nvm.sh" ]]; then
        nvm_dir="$dir"
        break
      fi
    done
  fi

  [[ -z "$nvm_dir" || ! -s "$nvm_dir/nvm.sh" ]] && return 1
  export NVM_DIR="$nvm_dir"
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}

nvm()  { _load_nvm && command nvm  "$@"; }
node() { _load_nvm && command node "$@"; }
npm()  { _load_nvm && command npm  "$@"; }
npx()  { _load_nvm && command npx  "$@"; }

# atuin
[ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"