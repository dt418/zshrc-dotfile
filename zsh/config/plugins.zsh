# =========================
# PLUGINS & TOOLS INIT
# =========================

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (smart cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# zsh-autosuggestions
() {
  local f
  for f in \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  do
    [[ -f "$f" ]] && source "$f" && break
  done
}

# zsh-syntax-highlighting (phải load cuối cùng)
() {
  local f
  for f in \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  do
    [[ -f "$f" ]] && source "$f" && break
  done
}

# atuin (better history)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi
