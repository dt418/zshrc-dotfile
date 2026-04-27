# 🛠 dotfiles

Personal shell configuration organized in a **modular dotfile** style — one function per file, easy to customize and portable across machines.

---

## 📁 Structure

```
dotfiles/
├── install.sh                    ← Install/uninstall script
├── Makefile                      ← Shortcuts: make install, make update...
├── .gitignore
├── README.md
├── test/
│   └── zsh_test.sh               ← Smoke tests for aliases/functions
├── starship/
│   └── starship.toml             ← ~/.config/starship.toml
└── zsh/
    ├── .zshenv                   ← ~/.zshenv (core env for interactive + non-interactive)
    ├── zshrc                     ← ~/.zshrc  (entry point, only sources modules)
    └── config/
        ├── env.zsh               ← entrypoint env, detects OS and sources appropriate module
        ├── env.shared.zsh        ← shared runtime: bun hook, lazy NVM, atuin, envman
        ├── env.linux.zsh         ← Linux-specific env (Linuxbrew, custom paths)
        ├── env.macos.zsh         ← macOS-specific env (Homebrew Apple Silicon/Intel)
        ├── options.zsh           ← ZSH options + HISTSIZE
        ├── completion.zsh        ← compinit, zstyle, docker/kubectl completion
        ├── plugins.zsh           ← fzf, zoxide, starship, autosuggestions, syntax-highlight, atuin
        ├── aliases.zsh           ← modern CLI, git, docker, k8s, system
        ├── functions.zsh         ← fsearch, hs, hgrep, sgrep, dsearch, lsearch, dklog, log
        ├── keybindings.zsh       ← bindkey
        ├── history-auto-repair.zsh
        ├── history-repair.sh
        └── local.zsh             ← (NOT committed) per-machine overrides
```

> **`local.zsh`** loads last — use it to override aliases, add env vars, or machine-specific config without editing shared files.

> **`.zshenv`** is always loaded first by Zsh (even non-interactive shells). Keep only essential environment variables; avoid heavy `source`/`eval` here.

---

## ⚡ Quick Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Done. Open a new terminal or run `source ~/.zshrc`.

---

## 🔧 Requirements

The script checks and auto-installs missing tools/plugins. Full checklist:

### Zsh Plugins (auto-installed via `./install.sh --plugins`)

| Plugin | Purpose |
|---|---|
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart cd |
| [starship](https://starship.rs/) | Prompt |
| [atuin](https://github.com/atuinsh/atuin) | Enhanced history |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Command suggestions |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Syntax highlighting |

### CLI Tools (auto-installed via `./install.sh --tools`)

| Tool | Purpose |
|---|---|
| [eza](https://github.com/eza-community/eza) | `ls` replacement |
| [bat](https://github.com/sharkdp/bat) | `cat` replacement |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` replacement |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI |
| [btop](https://github.com/aristocratsoftics/btop) | System monitor |
| [duf](https://github.com/muesli/duf) | Disk usage |
| [nvim](https://neovim.io/) | Neovim |
| [k9s](https://k9scli.io/) | K8s dashboard |
| [`fixpyenv`](#fixpyenv) | Auto-fix pyenv shim/lock errors |

### `fixpyenv`

Aliases: `fixpyenv` — Runs the `fix-pyenv.sh` script to resolve **"Failed to load pyenv"** or **log stream** errors on shell startup. The script runs automatically via `zshrc`, but you can invoke it manually if issues occur:

```bash
fixpyenv
```

The script will:
- Find and remove stale pyenv shim files
- Clean `__pycache__` directories in `~/.pyenv/versions/`
- Fix permission issues on pyenv directories

### Automatic Installation

```bash
./install.sh --plugins   # Check and install zsh plugins
./install.sh --tools     # Check and install CLI tools
./install.sh --doctor    # Check all tools
```

The script auto-selects install location:
- **User mode**: `~/.local/bin`
- **Sudo mode**: `/usr/local/bin`

---

## 📖 Aliases

### Modern CLI

| Alias | Command | Description |
|---|---|---|
| `ls` | `eza --icons` | List files with icons |
| `ll` | `eza -lah --icons` | Detailed list |
| `la` | `eza -a --icons` | Include hidden files |
| `tree` | `eza --tree --icons` | Tree view |
| `cat` | `bat` | View file with syntax highlighting |
| `grep` | `rg` | Faster search |
| `rgd` | `rg -g "!*.log" -g "!node_modules"` | rg ignoring logs and node_modules |

### Git

| Alias | Command |
|---|---|
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add .` |
| `gc` | `git commit` |
| `gcm "msg"` | `git commit -m "msg"` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `glog` | `git log --oneline --graph --decorate` |
| `lg` | `lazygit` |

### Docker

| Alias | Command |
|---|---|
| `d` | `docker` |
| `dc` | `docker compose` |
| `dps` | `docker ps` |
| `dpa` | `docker ps -a` |
| `di` | `docker images` |
| `dex` | `docker exec -it` |
| `dlog` | `docker logs -f` |
| `ld` | `lazydocker` |
| `ct` | `ctop` |

### Kubernetes

| Alias | Command |
|---|---|
| `k` | `k9s` |
| `kgp` | `kubectl get pods` |
| `kgs` | `kubectl get svc` |
| `kgn` | `kubectl get nodes` |

### System

| Alias | Command |
|---|---|
| `cls` | `clear` |
| `bt` | `btop` |
| `df` | `duf` |
| `reload` | `source ~/.zshrc` |

---

## 🔍 Functions

### `fsearch <pattern>`
Search file content → preview with bat → open in nvim at correct line.
```bash
fsearch "TODO"
```

### `hs <pattern>`
Search config files (yaml, toml, json) with fzf preview.
```bash
hs "traefik"
```

### `hgrep <pattern>`
Search with 3 lines context in `*.yml`, `*.yaml`, `*.env`.
```bash
hgrep "DATABASE_URL"
```

### `sgrep <pattern> <service>`
Search inside `services/<service>` directory.
```bash
sgrep "PORT" api
```

### `dsearch <pattern>`
Search inside docker-compose files.
```bash
dsearch "volumes"
```

### `lsearch <pattern>`
Search in `/var/log` and `~/logs`.
```bash
lsearch "error"
```

### `dklog <service> <pattern>`
View docker compose logs + realtime filter.
```bash
dklog api "ERROR"
```

### `log <service> [pattern]`
View docker or k8s logs depending on `MODE` variable.
```bash
log api "panic"
MODE=k8s log my-pod "timeout"
```

---

## 🛠 Workflow

### Update dotfiles

```bash
# Edit files in ~/dotfiles/zsh/
vim ~/dotfiles/zsh/config/aliases.zsh

# Reload immediately
reload   # or: source ~/.zshrc

# Commit and push
cd ~/dotfiles
git add . && git commit -m "feat: add new alias"
git push
```

### Sync to another machine

```bash
git pull   # in ~/dotfiles/
```

Changes take effect immediately thanks to symlinks — no need to re-run `install.sh`.

### Manage with chezmoi (optional)

The repo keeps its current structure. These commands add an optional chezmoi-based workflow:

```bash
# Install chezmoi to ~/.local/bin
make chezmoi-install

# Initialize from this repo and apply immediately
make chezmoi-init

# Apply new changes
make chezmoi-apply
```

### Use TUI menu for quick actions

```bash
make menu
# or
./install.sh --menu
```

Menu supports: `Install`, `Update`, `Doctor`, `Plugins`, `Tools`, `Test`, `Benchmark`, `Edit`, `Uninstall`.
If `fzf` is available it uses fuzzy menu; otherwise falls back to `select`-style menu.

### Quick syntax check

```bash
make lint
```

### Run smoke tests

```bash
make test
```

Run a single alias test:

```bash
make test TEST="alias ls"
```

### Uninstall

```bash
cd ~/dotfiles && ./install.sh --uninstall
```

---

## ⚙️ Per-machine Customization (`local.zsh`)

Create `~/.config/zsh/local.zsh` for machine-specific settings (not committed):

```bash
# Example: ~/.config/zsh/local.zsh

export WORK_TOKEN="ghp_..."
export KUBECONFIG="$HOME/.kube/work-cluster.yaml"
alias vpn="sudo openvpn ~/work.ovpn"
```

---

## 🚀 Proposed Improvements

See details in [`IMPROVEMENTS.md`](./IMPROVEMENTS.md).

---

## 💡 Tips

- **`Ctrl+R`** → fzf history search (or use atuin if installed)
- **`z <directory>`** → jump to frequently-used directories (zoxide)
- **`fsearch`** → search codebase, Enter opens nvim at correct line
- History auto-repairs on corruption via `history-auto-repair.zsh`
