# =========================
# COMPLETION SYSTEM
# =========================
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''

# Docker completion
if command -v docker >/dev/null 2>&1; then
  source <(docker completion zsh)
fi

# Kubectl completion
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
