#!/usr/bin/env bash
# =============================================================
# dotfiles/install.sh
# Usage:
#   ./install.sh              — cài đặt (tạo symlinks)
#   ./install.sh --uninstall  — gỡ cài đặt (xóa symlinks, khôi phục backup)
#   ./install.sh --doctor     — kiểm tra tool nào chưa cài
#   ./install.sh --menu       — TUI menu (fzf/select) để chọn tác vụ
# =============================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CONFIG_DIR="$HOME/.config/zsh"
STARSHIP_CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
ZSHENV_FILE="$HOME/.zshenv"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${CYAN}[info]${RESET}  $*"; }
success() { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn() { echo -e "${YELLOW}[warn]${RESET}  $*"; }
miss() { echo -e "${RED}[MISS]${RESET}  $*"; }
error() {
	echo -e "${RED}[error]${RESET} $*"
	exit 1
}

# ─── Helpers ──────────────────────────────────────────────────────────────────

backup_if_needed() {
	local target="$1"
	if [[ -e "$target" && ! -L "$target" ]]; then
		mkdir -p "$BACKUP_DIR"
		cp -r "$target" "$BACKUP_DIR/"
		warn "Backed up $(basename "$target") → $BACKUP_DIR"
	fi
}

link() {
	local src="$1" dest="$2"
	backup_if_needed "$dest"
	ln -sfn "$src" "$dest"
	success "Linked $(basename "$dest")"
}

run_menu() {
	local choice
	local fzf_opts="--prompt='  Select action > ' --height=50% --reverse --color=bg:+1,pointer:6,highlight:6"

	if ! command -v fzf >/dev/null 2>&1; then
		error "fzf not installed. Install with: brew install fzf"
	fi

	choice=$(
		printf "📦  Install      │ Apply dotfiles symlinks to home\n" \
			"🔄  Update       │ Git pull + reload config\n" \
			"🩺  Doctor       │ Check installed tools\n" \
			"✅  Test         │ Run smoke tests\n" \
			"📊  Benchmark    │ Measure shell startup time\n" \
			"📝  Edit Config  │ Open dotfiles in nvim\n" \
			"🗑️  Uninstall    │ Remove symlinks (with backup)\n" \
			"❌  Exit         │ Quit menu\n" |
			fzf --expect=Enter --header=$'╔══════════════════════════════════════════════════════╗\n║              🚀 DOTFILES MANAGEMENT MENU               ║\n╚══════════════════════════════════════════════════════╝' \
				--delimiter='│' --with-nth=1 \
				--preview='echo {2}' \
				--preview-window=down:3:wrap \
				$fzf_opts
	)

	key="$choice"
	choice=$(echo "$choice" | tail -1)

	case "$choice" in
	*"Install") cmd_install ;;
	*"Update") cmd_update ;;
	*"Doctor") cmd_doctor ;;
	*"Test") cmd_test ;;
	*"Benchmark") cmd_benchmark ;;
	*"Edit Config") cmd_edit ;;
	*"Uninstall") cmd_uninstall_confirm ;;
	*"Exit" | "") info "Bye." ;;
	esac
}

# ─── Install ──────────────────────────────────────────────────────────────────

cmd_install() {
	echo ""
	echo -e "${BOLD}Installing dotfiles from: $DOTFILES_DIR${RESET}"
	echo ""

	info "Setting up ~/.config/zsh/"
	mkdir -p "$ZSH_CONFIG_DIR"

	for f in "$DOTFILES_DIR"/zsh/config/*.zsh "$DOTFILES_DIR"/zsh/config/*.sh; do
		[[ -f "$f" ]] || continue
		link "$f" "$ZSH_CONFIG_DIR/$(basename "$f")"
	done

	info "Setting up ~/.zshrc"
	link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

	info "Setting up ~/.zshenv"
	link "$DOTFILES_DIR/zsh/.zshenv" "$ZSHENV_FILE"

	info "Setting up ~/.config/starship.toml"
	mkdir -p "$STARSHIP_CONFIG_DIR"
	link "$DOTFILES_DIR/starship/starship.toml" "$STARSHIP_CONFIG_FILE"

	info "Setting up Git hooks"
	if [[ -f "$DOTFILES_DIR/package.json" ]]; then
		(cd "$DOTFILES_DIR" && npx lefthook install 2>/dev/null) || true
	fi

	echo ""
	success "Done! Run: source ~/.zshrc"
	echo ""
}

# ─── Update ───────────────────────────────────────────────────────────────────

cmd_update() {
	echo ""
	echo -e "${BOLD}Updating dotfiles...${RESET}"
	cd "$DOTFILES_DIR"
	if git diff --quiet && git diff --cached --quiet; then
		info "No local changes. Pulling from remote..."
		git pull --ff-only
		success "Updated to latest."
	else
		warn "You have uncommitted changes. Commit or stash first."
		git status --short
		echo ""
		read -r -p "Stash and pull? [y/N] " reply
		if [[ "$reply" =~ ^[Yy]$ ]]; then
			git stash
			git pull --ff-only
			success "Updated. Restoring stash..."
			git stash pop
		else
			info "Update cancelled."
			return
		fi
	fi
	source ~/.zshrc
	echo ""
	success "Done. Config reloaded."
	echo ""
}

# ─── Test ─────────────────────────────────────────────────────────────────────

cmd_test() {
	echo ""
	echo -e "${BOLD}Running smoke tests...${RESET}"
	zsh "$DOTFILES_DIR/test/zsh_test.sh"
}

# ─── Benchmark ───────────────────────────────────────────────────────────────

cmd_benchmark() {
	echo ""
	echo -e "${BOLD}Measuring shell startup time (5 runs)...${RESET}"
	for i in 1 2 3 4 5; do time zsh -i -c exit 2>&1; done | grep real
}

# ─── Edit Config ──────────────────────────────────────────────────────────────

cmd_edit() {
	if ! command -v nvim >/dev/null 2>&1; then
		warn "nvim not installed. Opening with vim..."
		nvim="$EDITOR"
	fi
	nvim "$DOTFILES_DIR"
}

# ─── Uninstall ────────────────────────────────────────────────────────────────

cmd_uninstall_confirm() {
	echo ""
	warn "⚠️  This will remove all dotfile symlinks from your home directory."
	read -r -p "Continue? [y/N] " reply
	if [[ ! "$reply" =~ ^[Yy]$ ]]; then
		info "Cancelled."
		return
	fi
	cmd_uninstall
}

cmd_uninstall() {
	echo ""
	echo -e "${BOLD}Uninstalling dotfiles...${RESET}"
	echo ""

	local removed=0

	for f in "$ZSH_CONFIG_DIR"/*.zsh "$ZSH_CONFIG_DIR"/*.sh; do
		[[ -L "$f" ]] || continue
		target="$(readlink "$f")"
		if [[ "$target" == "$DOTFILES_DIR"* ]]; then
			rm "$f"
			warn "Removed symlink: $(basename "$f")"
			((removed++))
		fi
	done

	if [[ -L "$HOME/.zshrc" ]]; then
		target="$(readlink "$HOME/.zshrc")"
		if [[ "$target" == "$DOTFILES_DIR"* ]]; then
			rm "$HOME/.zshrc"
			warn "Removed symlink: ~/.zshrc"
			((removed++))
		fi
	fi

	if [[ -L "$ZSHENV_FILE" ]]; then
		target="$(readlink "$ZSHENV_FILE")"
		if [[ "$target" == "$DOTFILES_DIR"* ]]; then
			rm "$ZSHENV_FILE"
			warn "Removed symlink: ~/.zshenv"
			((removed++))
		fi
	fi

	if [[ -L "$STARSHIP_CONFIG_FILE" ]]; then
		target="$(readlink "$STARSHIP_CONFIG_FILE")"
		if [[ "$target" == "$DOTFILES_DIR"* ]]; then
			rm "$STARSHIP_CONFIG_FILE"
			warn "Removed symlink: ~/.config/starship.toml"
			((removed++))
		fi
	fi

	latest_backup=$(ls -td "$HOME/.dotfiles-backup/"*/ 2>/dev/null | head -1)
	if [[ -n "$latest_backup" && -d "$latest_backup" ]]; then
		echo ""
		info "Found backup: $latest_backup"
		read -r -p "Restore this backup? [y/N] " reply
		if [[ "$reply" =~ ^[Yy]$ ]]; then
			for f in "$latest_backup"/*; do
				[[ -f "$f" ]] || continue
				name="$(basename "$f")"
				case "$name" in
				.zshrc) cp "$f" "$HOME/.zshrc" && success "Restored ~/.zshrc" ;;
				.zshenv) cp "$f" "$ZSHENV_FILE" && success "Restored ~/.zshenv" ;;
				starship.toml) cp "$f" "$STARSHIP_CONFIG_FILE" && success "Restored ~/.config/starship.toml" ;;
				*.zsh | *.sh) cp "$f" "$ZSH_CONFIG_DIR/$name" && success "Restored $name" ;;
				esac
			done
		fi
	fi

	echo ""
	success "Uninstall complete. Removed $removed symlink(s)."
	echo ""
}

# ─── Doctor ───────────────────────────────────────────────────────────────────

cmd_doctor() {
	echo ""
	echo -e "${BOLD}Checking required tools...${RESET}"
	echo ""

	check() {
		local cmd="$1" install_hint="$2"
		if command -v "$cmd" &>/dev/null; then
			success "$cmd"
		else
			miss "$cmd  →  $install_hint"
		fi
	}

	check zsh "apt install zsh"
	check starship "curl -sS https://starship.rs/install.sh | sh"
	check eza "brew install eza"
	check bat "brew install bat"
	check rg "brew install ripgrep"
	check fzf "brew install fzf"
	check zoxide "brew install zoxide"
	check atuin "curl --proto '=https' -LsSf https://setup.atuin.sh | sh"
	check lazygit "brew install lazygit"
	check lazydocker "brew install lazydocker"
	check btop "brew install btop"
	check duf "brew install duf"
	check nvim "brew install neovim"
	check docker "https://docs.docker.com/engine/install"
	check kubectl "brew install kubectl"
	check k9s "brew install k9s"
	check ctop "brew install ctop"

	echo ""
}

# ─── Entry point ──────────────────────────────────────────────────────────────

case "${1:-}" in
--menu) run_menu ;;
--uninstall) cmd_uninstall ;;
--doctor) cmd_doctor ;;
"") cmd_install ;;
*) error "Unknown option: $1. Use --menu, --uninstall or --doctor." ;;
esac
