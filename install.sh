#!/usr/bin/env bash
# =============================================================
# dotfiles/install.sh — Symlink dotfiles to the right places
# =============================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CONFIG_DIR="$HOME/.config/zsh"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[info]${RESET}  $*"; }
success() { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET}  $*"; }
error()   { echo -e "${RED}[error]${RESET} $*"; }

# ─── Backup a file if it exists and is NOT already a symlink to our dotfiles ──
backup_if_needed() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$target" "$BACKUP_DIR/"
    warn "Backed up $(basename "$target") → $BACKUP_DIR"
  fi
}

# ─── Create a symlink, removing stale links first ─────────────────────────────
link() {
  local src="$1"
  local dest="$2"
  backup_if_needed "$dest"
  ln -sfn "$src" "$dest"
  success "Linked $dest → $src"
}

echo ""
echo -e "${BOLD}Installing dotfiles from: $DOTFILES_DIR${RESET}"
echo ""

# ─── ~/.config/zsh/ ───────────────────────────────────────────────────────────
info "Setting up ~/.config/zsh/"
mkdir -p "$ZSH_CONFIG_DIR"

for f in "$DOTFILES_DIR"/zsh/config/*.zsh "$DOTFILES_DIR"/zsh/config/*.sh; do
  [[ -f "$f" ]] || continue
  link "$f" "$ZSH_CONFIG_DIR/$(basename "$f")"
done

# ─── ~/.zshrc ─────────────────────────────────────────────────────────────────
info "Setting up ~/.zshrc"
link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

echo ""
success "All done! Open a new terminal or run: source ~/.zshrc"
echo ""
