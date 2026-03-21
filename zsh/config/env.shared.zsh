# =========================
# SHARED ENVIRONMENT
# =========================

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# nvm — lazy load để tránh làm chậm startup
_load_nvm() {
  for cmd in nvm node npm npx yarn pnpm bun; do
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
nvm()  { _load_nvm && nvm  "$@"; }
node() { _load_nvm && node "$@"; }
npm()  { _load_nvm && npm  "$@"; }
npx()  { _load_nvm && npx  "$@"; }
yarn() { _load_nvm && yarn "$@"; }
pnpm() { _load_nvm && pnpm "$@"; }
bun()  { _load_nvm && bun  "$@"; }

# atuin
[ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
