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
PLUGIN_NAMES=("fzf" "zoxide" "starship" "atuin" "zsh-autosuggestions" "zsh-syntax-highlighting")
PLUGIN_DESCS=("Fuzzy finder" "Smart cd" "Prompt" "Better history" "Autocomplete suggestions" "Syntax highlighting")
PLUGIN_INSTALL=(
  "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --update-rc"
  "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"
  "curl -sS https://starship.rs/install.sh | sh"
  "curl --proto '=https' -LsSf https://setup.atuin.sh | sh"
  "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  "git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
)
PLUGIN_CHECK=(
  "[[ -f ~/.fzf.zsh || -f ~/.fzf/bin/fzf ]]"
  "[[ -f ~/.local/bin/zoxide || -f /usr/local/bin/zoxide ]]"
  "[[ -f ~/.local/bin/starship || -f /usr/local/bin/starship ]]"
  "[[ -f ~/.atuin/bin/atuin || -f /usr/local/bin/atuin ]]"
  "[[ -f ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh || -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]"
  "[[ -f ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh || -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]"
)

TOOL_NAMES=("eza" "bat" "rg" "lazygit" "lazydocker" "btop" "duf" "nvim" "k9s")
TOOL_DESCS=("Modern ls" "Cat with syntax" "Ripgrep" "Git TUI" "Docker TUI" "System monitor" "Disk usage" "Neovim" "K8s dashboard")
TOOL_INSTALL=(
  "curl -sL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xzf - -C \"\$INSTALL_BIN\""
  "curl -sL \$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*x86_64-unknown-linux-musl.tar.gz\"' | head -1 | cut -d'\"' -f4) | tar xzf - -C /tmp && mv /tmp/bat-*/bat \"\$INSTALL_BIN/\" && rm -rf /tmp/bat*"
  "curl -sL \$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*x86_64-unknown-linux-musl.tar.gz\"' | head -1 | cut -d'\"' -f4) | tar xzf - -C /tmp && mv /tmp/rg-*/rg \"\$INSTALL_BIN/\" && rm -rf /tmp/rg*"
  "curl -sL \$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*Linux_x86_64.tar.gz\"' | head -1 | cut -d'\"' -f4) | tar xzf - -C /tmp && mv /tmp/lazygit \"\$INSTALL_BIN/\" && rm -rf /tmp/lazygit*"
  "curl -sL \$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*Linux_x86_64.tar.gz\"' | head -1 | cut -d'\"' -f4) | tar xzf - -C /tmp && mv /tmp/lazydocker \"\$INSTALL_BIN/\" && rm -rf /tmp/lazydocker*"
  "curl -sL \$(curl -s https://api.github.com/repos/aristocratos/btop/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*x86_64-linux-musl.tbz\"' | head -1 | cut -d'\"' -f4) | tar xjf - -C /tmp && mv /tmp/btop*/btop \"\$INSTALL_BIN/\" && rm -rf /tmp/btop*"
  "curl -sL \$(curl -s https://api.github.com/repos/muesli/duf/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*amd64.deb\"' | head -1 | cut -d'\"' -f4) -o /tmp/duf.deb && ar x /tmp/duf.deb && tar xzf data.tar.gz -C /tmp && mv /tmp/usr/bin/duf \"\$INSTALL_BIN/\" && rm -rf /tmp/duf.deb /tmp/data.tar.gz /tmp/usr"
  "curl -sL https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o \"\$INSTALL_BIN/nvim\" && chmod +x \"\$INSTALL_BIN/nvim\" && (\"\$INSTALL_BIN/nvim\" --appimage-extract >/dev/null 2>&1 && mv squashfs-root \"\$HOME/.local/\" 2>/dev/null && ln -sf \"\$HOME/.local/squashfs-root/usr/bin/nvim\" \"\$INSTALL_BIN/nvim\" 2>/dev/null) || true"
  "curl -sL \$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -o '\"browser_download_url\": \"[^\"]*Linux_amd64.tar.gz\"' | head -1 | cut -d'\"' -f4) | tar xzf - -C /tmp && mv /tmp/k9s \"\$INSTALL_BIN/\" && rm -rf /tmp/k9s*"
)

install_deps() {
  echo -e "${BOLD}Checking dependencies...${RESET}"

  local missing_deps=()
  command -v git >/dev/null 2>&1 || missing_deps+=("git")
  command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
  command -v tar >/dev/null 2>&1 || missing_deps+=("tar")

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    warn "Missing dependencies: ${missing_deps[*]}"
    if command -v sudo >/dev/null 2>&1; then
      echo -e "${CYAN}Installing dependencies...${RESET}"
      sudo apt-get update -qq 2>/dev/null
      sudo apt-get install -y "${missing_deps[@]}" 2>/dev/null && success "Dependencies installed" || warn "Could not install dependencies automatically"
    else
      warn "Please install: sudo apt-get install ${missing_deps[*]}"
    fi
  else
    success "All dependencies satisfied"
  fi
  echo ""
}

detect_install_mode() {
  if [[ $EUID -eq 0 ]]; then
    INSTALL_BIN="/usr/local/bin"
    INSTALL_MODE="system-wide (sudo)"
  elif sudo -n true 2>/dev/null; then
    INSTALL_BIN="/usr/local/bin"
    INSTALL_MODE="system-wide (sudo)"
  else
    INSTALL_BIN="$HOME/.local/bin"
    INSTALL_MODE="user (~/.local/bin)"
  fi
  mkdir -p "$INSTALL_BIN"
}

TOOL_CHECK=(
  "command -v eza || [[ -f /usr/local/bin/eza ]] || [[ -f ~/.local/bin/eza ]]"
  "command -v bat || [[ -f /usr/local/bin/bat ]] || [[ -f ~/.local/bin/bat ]]"
  "command -v rg || [[ -f /usr/local/bin/rg ]] || [[ -f ~/.local/bin/rg ]]"
  "command -v lazygit || [[ -f /usr/local/bin/lazygit ]] || [[ -f ~/.local/bin/lazygit ]]"
  "command -v lazydocker || [[ -f /usr/local/bin/lazydocker ]] || [[ -f ~/.local/bin/lazydocker ]]"
  "command -v btop || [[ -f /usr/local/bin/btop ]] || [[ -f ~/.local/bin/btop ]]"
  "command -v duf || [[ -f /usr/local/bin/duf ]] || [[ -f ~/.local/bin/duf ]]"
  "command -v nvim || [[ -f /usr/local/bin/nvim ]] || [[ -f ~/.local/bin/nvim ]]"
  "command -v k9s || [[ -f /usr/local/bin/k9s ]] || [[ -f ~/.local/bin/k9s ]]"
)
TOOL_CHECK=(
  "command -v eza || [[ -f ~/.local/bin/eza ]]"
  "command -v bat || [[ -f ~/.local/bin/bat ]]"
  "command -v rg || [[ -f ~/.local/bin/rg ]]"
  "command -v lazygit || [[ -f ~/.local/bin/lazygit ]]"
  "command -v lazydocker || [[ -f ~/.local/bin/lazydocker ]]"
  "command -v btop || [[ -f ~/.local/bin/btop ]]"
  "command -v duf || [[ -f ~/.local/bin/duf ]]"
  "command -v nvim || [[ -f ~/.local/bin/nvim ]]"
  "command -v k9s || [[ -f ~/.local/bin/k9s ]]"
)
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
	if ! command -v fzf >/dev/null 2>&1; then
		error "fzf not installed. Install with: brew install fzf"
	fi

	local choice

	if [[ -t 0 ]]; then
		local fzf_opts="--prompt='Select action > ' --height=50% --reverse --color=bg:+1,pointer:6,highlight:6 --bind=enter:accept"

		choice=$(
			printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" \
				"📦 Install      │ Apply dotfiles symlinks to home" \
				"🔄 Update       │ Git pull + reload config" \
				"🩺 Doctor       │ Check installed tools" \
				"🔌 Plugins      │ Check and install missing zsh plugins" \
				"🔧 Tools        │ Check and install missing tools" \
				"✅ Test         │ Run smoke tests" \
				"📊 Benchmark    │ Measure shell startup time" \
				"📝 Edit Config  │ Open dotfiles in nvim" \
				"🗑️ Uninstall    │ Remove symlinks (with backup)" \
				"❌ Exit         │ Quit menu" |
				fzf --delimiter='│' --with-nth=1 $fzf_opts
		)
	else
		info "No TTY detected. Using fallback menu..."
		local options=(
			"Install - Apply dotfiles symlinks to home"
			"Update - Git pull + reload config"
			"Doctor - Check installed tools"
			"Plugins - Check and install missing zsh plugins"
			"Tools - Check and install missing tools"
			"Test - Run smoke tests"
			"Benchmark - Measure shell startup time"
			"Edit Config - Open dotfiles in nvim"
			"Uninstall - Remove symlinks (with backup)"
			"Exit - Quit menu"
		)

		PS3="Select action (1-${#options[@]}): "
		select opt in "${options[@]}"; do
			if [[ -n "$opt" ]]; then
				choice="$opt"
				break
			fi
		done
	fi

	case "$choice" in
	Install*) cmd_install ;;
	Update*) cmd_update ;;
	Doctor*) cmd_doctor ;;
	Plugins*) cmd_check_plugins ;;
	Tools*) cmd_check_tools ;;
	Test*) cmd_test ;;
	Benchmark*) cmd_benchmark ;;
	Edit*) cmd_edit ;;
	Uninstall*) cmd_uninstall_confirm ;;
	Exit* | "") info "Bye." ;;
	*)
		if [[ -z "$choice" ]]; then
			info "Bye."
		else
			error "Unknown choice: $choice"
		fi
		;;
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
		git pull --no-rebase
		success "Updated."
	else
		warn "You have uncommitted changes. Commit or stash first."
		git status --short
		echo ""
		read -r -p "Stash and pull? [y/N] " reply
		if [[ "$reply" =~ ^[Yy]$ ]]; then
			git stash
			git pull --no-rebase
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

cmd_check_plugins() {
	echo ""
	echo -e "${BOLD}Checking zsh plugins...${RESET}"
	echo ""
	install_deps

	local missing_idx=()
	for i in "${!PLUGIN_NAMES[@]}"; do
		if ! eval "${PLUGIN_CHECK[$i]}" 2>/dev/null; then
			missing_idx+=("$i")
			miss "${PLUGIN_NAMES[$i]} - ${PLUGIN_DESCS[$i]}"
		else
			success "${PLUGIN_NAMES[$i]}"
		fi
	done

	echo ""
	if [[ ${#missing_idx[@]} -eq 0 ]]; then
		success "All plugins installed!"
	else
		info "${#missing_idx[@]} plugin(s) missing"
		echo ""
		read -r -p "Install missing plugins? [Y/n] " reply
		if [[ ! "$reply" =~ ^[Nn]$ ]]; then
			cmd_install_plugins "${missing_idx[@]}"
		else
			info "Skipped."
		fi
	fi
	echo ""
}

cmd_install_plugins() {
	echo ""
	echo -e "${BOLD}Installing zsh plugins...${RESET}"
	echo ""

	for idx in "$@"; do
		local name="${PLUGIN_NAMES[$idx]}"
		local desc="${PLUGIN_DESCS[$idx]}"
		local install_cmd="${PLUGIN_INSTALL[$idx]}"
		echo -e "${CYAN}Installing${RESET} $name - $desc..."
		if eval "$install_cmd" 2>&1; then
			success "$name installed"
		else
			miss "Failed to install $name"
		fi
		echo ""
	done
	success "Done! Restart shell or run: source ~/.zshrc"
	echo ""
}

cmd_check_tools() {
	echo ""
	echo -e "${BOLD}Checking tools...${RESET}"
	detect_install_mode
	echo -e "${CYAN}Install mode:${RESET} $INSTALL_MODE ($INSTALL_BIN)"
	echo ""
	install_deps

	local missing_idx=()
	for i in "${!TOOL_NAMES[@]}"; do
		if ! eval "${TOOL_CHECK[$i]}" 2>/dev/null; then
			missing_idx+=("$i")
			miss "${TOOL_NAMES[$i]} - ${TOOL_DESCS[$i]}"
		else
			success "${TOOL_NAMES[$i]}"
		fi
	done

	echo ""
	if [[ ${#missing_idx[@]} -eq 0 ]]; then
		success "All tools installed!"
	else
		info "${#missing_idx[@]} tool(s) missing"
		echo ""
		read -r -p "Install missing tools? [Y/n] " reply
		if [[ ! "$reply" =~ ^[Nn]$ ]]; then
			cmd_install_tools "${missing_idx[@]}"
		else
			info "Skipped."
		fi
	fi
	echo ""
}

cmd_install_tools() {
	detect_install_mode
	echo ""
	echo -e "${BOLD}Installing tools to $INSTALL_BIN...${RESET}"
	echo ""

	for idx in "$@"; do
		local name="${TOOL_NAMES[$idx]}"
		local desc="${TOOL_DESCS[$idx]}"
		local install_cmd="${TOOL_INSTALL[$idx]}"
		echo -e "${CYAN}Installing${RESET} $name - $desc..."
		if eval "INSTALL_BIN=$INSTALL_BIN HOME=$HOME $install_cmd" 2>&1; then
			success "$name installed"
		else
			miss "Failed to install $name"
		fi
		echo ""
	done
	success "Done! Restart shell or run: source ~/.zshrc"
	echo ""
}

# ─── Help ────────────────────────────────────────────────────────────────

	cmd_help() {
	echo "Usage: install.sh [OPTION]"
	echo ""
	echo "Options:"
	echo "  --help, -h     Show this help message"
	echo "  --menu         Launch interactive TUI menu (default)"
	echo "  --uninstall    Remove dotfile symlinks and restore backups"
	echo "  --doctor       Check for required tools and dependencies"
	echo "  --plugins      Check and install missing zsh plugins"
	echo "  --tools       Check and install missing tools"
	echo "  (no args)      Install dotfiles (same as --menu)"
	echo ""
	echo "Examples:"
	echo "  ./install.sh          # Interactive menu"
	echo "  ./install.sh --menu   # Same as above"
	echo "  ./install.sh --plugins   # Check and install plugins"
	echo "  ./install.sh --tools    # Check and install tools"
	echo "  ./install.sh --uninstall  # Remove dotfiles"
	echo ""
}

# ─── Entry point ──────────────────────────────────────────────────────────────

case "${1:-}" in
--help | -h) cmd_help ;;
--menu) run_menu ;;
--uninstall) cmd_uninstall ;;
--doctor) cmd_doctor ;;
--plugins) cmd_check_plugins ;;
--tools) cmd_check_tools ;;
"") cmd_install ;;
*) error "Unknown option: $1. Use --help, --menu, --uninstall, --doctor, --plugins or --tools." ;;
esac
