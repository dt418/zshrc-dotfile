# =========================
# MODERN CLI
# =========================
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias la="eza -a --icons"
alias tree="eza --tree --icons"
alias cat="bat"
alias grep="rg"
alias rgd='rg -g "!*.log" -g "!node_modules"'

# =========================
# GIT
# =========================
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias glog="git log --oneline --graph --decorate"
alias lg="lazygit"

# =========================
# DOCKER
# =========================
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias dlog="docker logs -f"
alias ld="lazydocker"
alias ct="ctop"

# =========================
# KUBERNETES
# =========================
alias k="k9s"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes"

# =========================
# SYSTEM
# =========================
alias cls="clear"
alias reload="source ~/.zshrc"
alias bt="btop"
alias df="duf"

# =========================
# pyenv
# =========================
: ${ZSH_CONFIG:="$HOME/.config/zsh"}
alias fixpyenv="bash $ZSH_CONFIG/fix-pyenv.sh"
