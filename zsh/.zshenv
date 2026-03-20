# =========================
# CORE ENV (all zsh modes)
# =========================
# Keep this file minimal and fast. It is loaded by Zsh for both
# interactive and non-interactive shells.

export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
