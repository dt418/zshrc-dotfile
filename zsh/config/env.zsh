# =========================
# ENVIRONMENT & PATH
# =========================
# Core exports are loaded in ~/.zshenv for both interactive and non-interactive shells.

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# nvm — lazy load để tránh làm chậm startup
_load_nvm() {
  unset -f nvm node npm npx yarn pnpm bun
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }

# brew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# atuin
[ -f "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
