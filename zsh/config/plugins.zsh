# =========================
# PLUGINS & TOOLS INIT
# =========================

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# starship prompt
eval "$(starship init zsh)"

# zsh-autosuggestions
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last)
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# atuin (better history)
eval "$(atuin init zsh)"
