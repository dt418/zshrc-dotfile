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

# Prepend Linux NVM node to PATH (before Windows NVM paths from WSL)
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  local nvm_version
  nvm_version=$(. "$NVM_DIR/nvm.sh" 2>/dev/null && nvm version default 2>/dev/null | sed 's/v//')
  if [[ -n "$nvm_version" && -d "$NVM_DIR/versions/node/v$nvm_version/bin" ]]; then
    export PATH="$NVM_DIR/versions/node/v$nvm_version/bin:$PATH"
  fi
fi
