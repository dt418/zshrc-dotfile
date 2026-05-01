# =========================
# CORE ENV (all zsh modes)
# =========================

# Chỉ base PATH — không tools
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export NODE_OPTIONS=--dns-result-order=ipv4first

# NVM_DIR is just a variable pointing to the path — DO NOT source nvm.sh here
export NVM_DIR="$HOME/.nvm"