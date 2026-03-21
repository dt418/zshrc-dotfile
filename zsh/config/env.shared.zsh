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
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }

# atuin
[ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
