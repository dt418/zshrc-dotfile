# =========================
# ENVIRONMENT ENTRYPOINT
# =========================
# Core exports are loaded in ~/.zshenv for both interactive and non-interactive shells.

ZSH_CONFIG="${ZSH_CONFIG:-$HOME/.config/zsh}"

# Shared runtime setup
[[ -f "$ZSH_CONFIG/env.shared.zsh" ]] && source "$ZSH_CONFIG/env.shared.zsh"

# OS-specific setup
case "$(uname -s)" in
  Darwin)
    [[ -f "$ZSH_CONFIG/env.macos.zsh" ]] && source "$ZSH_CONFIG/env.macos.zsh"
    ;;
  Linux)
    [[ -f "$ZSH_CONFIG/env.linux.zsh" ]] && source "$ZSH_CONFIG/env.linux.zsh"
    ;;
esac
