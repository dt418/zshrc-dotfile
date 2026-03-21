# AGENTS.md

> Guidelines for AI agents operating in this dotfiles repository.

---

## Overview

This repository manages **modular Zsh dotfiles** with a symlink-based installer. Configuration files are organized into small, focused modules loaded in a specific order.

---

## Commands

### Installation & Lifecycle
```bash
make install       # Apply dotfiles (create/update symlinks)
make uninstall     # Remove managed symlinks, optionally restore backup
make update        # git pull + source ~/.zshrc
```

### Linting & Testing
```bash
make lint          # Validate Zsh syntax (zsh -n) for all .zsh files
make test          # Run all smoke tests
make test TEST="alias ls"   # Run single alias check
make test TEST="assert_function fsearch"  # Run single function check
```

### Diagnostics
```bash
make doctor        # Check required external tools
make bench         # Measure shell startup time (5 runs)
make menu          # Interactive TUI menu
```

---

## Architecture

### Directory Structure
```
dotfiles/
├── install.sh              # Lifecycle manager (install/uninstall/doctor/menu)
├── Makefile                # Shortcut targets
├── test/zsh_test.sh        # Smoke tests for aliases/functions
├── starship/starship.toml  # Prompt config → ~/.config/starship.toml
├── lefthook.yml           # Git hooks configuration
├── commitlint.config.js    # Commit message linting
└── zsh/
    ├── .zshenv             # Core env (all modes, interactive + non-interactive)
    ├── zshrc               # Entry point (sources modules only, no logic)
    └── config/
        ├── env.zsh              # Entrypoint env, OS detection
        ├── env.shared.zsh        # Shared runtime: bun hook, lazy NVM, atuin, envman
        ├── env.linux.zsh         # Linux-specific env
        ├── env.macos.zsh         # macOS-specific env
        ├── options.zsh           # Shell/history options
        ├── completion.zsh        # compinit, completion styles
        ├── plugins.zsh           # fzf, zoxide, starship, plugins
        ├── aliases.zsh           # User aliases
        ├── functions.zsh         # User functions
        ├── keybindings.zsh       # bindkey configurations
        ├── history-auto-repair.zsh
        └── local.zsh             # Machine-specific overrides (NOT committed)
```

### Module Loading Order (in zshrc)
```
env.zsh → options.zsh → completion.zsh → plugins.zsh → 
aliases.zsh → functions.zsh → keybindings.zsh → 
history-auto-repair.zsh → local.zsh
```

---

## Code Style Guidelines

### Zsh Script Conventions
- **Shebang**: `#!/usr/bin/env zsh` (Zsh scripts), `#!/usr/bin/env bash` (bash scripts)
- **Error handling**: `set -euo pipefail` in test scripts; `set -e` in install.sh
- **Strict mode**: Enable in all new Zsh scripts

### File Organization
- `zsh/zshrc` - minimal entry point, only sources modules (no logic)
- `zsh/.zshenv` - minimal core exports; avoid heavy `source`/`eval`
- New shared behavior → `zsh/config/*.zsh` modules by responsibility
- Machine-specific overrides → `local.zsh` (never committed)

### Guarded Optional Integrations
All optional tool/plugin integrations MUST be guarded:
```zsh
# Command check
if command -v toolname >/dev/null 2>&1; then
    eval "$(toolname init zsh)"
fi

# File check
[[ -f "$path/to/config" ]] && source "$path/to/config"

# Non-empty file check
[[ -s "$path/to/file" ]] && eval "$(cat "$path/to/file")"
```

### Load Order Constraints
- `local.zsh` must stay **last** (override semantics)
- Syntax highlighting loaded at end of `plugins.zsh`
- Preserve module load order in `zsh/zshrc`

### Aliases Style
```zsh
# =========================
# GIT
# =========================
alias g="git"
alias gs="git status"

# Replace tools with modern alternatives
alias ls="eza --icons"
alias cat="bat"
```

### Functions Style
```zsh
function_name() {
  local arg1="$1"
  local arg2="${2:-default}"
  # implementation
}
```

### Section Headers
```zsh
# =========================
# SECTION NAME
# =========================
```

---

## Error Handling
```zsh
# Always check availability before using optional tools
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Defensive directory check
[[ -d "$ZSH_CONFIG_DIR" ]] || mkdir -p "$ZSH_CONFIG_DIR"

# Check file is not already a symlink before backing up
if [[ -e "$target" && ! -L "$target" ]]; then
    backup_if_needed "$target"
fi
```

---

## Testing

### Adding New Aliases
1. Add alias to `zsh/config/aliases.zsh` with proper category section
2. Add test assertion to `test/zsh_test.sh`: `assert_alias <alias_name>`
3. Verify: `make test` or `make test TEST="alias <name>"`

### Adding New Functions
1. Add function to `zsh/config/functions.zsh`
2. Add test assertion: `assert_function <function_name>`
3. Verify: `make test`

### Test Script Pattern
```zsh
#!/usr/bin/env zsh
set -euo pipefail

assert_alias() {
  local name="$1"
  alias "$name" >/dev/null || { echo "FAIL: alias $name missing"; exit 1; }
}

assert_function() {
  local name="$1"
  typeset -f "$name" >/dev/null || { echo "FAIL: function $name missing"; exit 1; }
}
```

---

## Commit Message Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code refactoring |
| `test` | Adding/updating tests |
| `chore` | Maintenance tasks |

### Examples
```
feat(aliases): add docker compose alias
fix(functions): handle empty pattern in fsearch
docs: update README with new aliases
```

---

## Git Hooks (Lefthook)

Pre-commit hooks run automatically before each commit:
- `make lint` - Validate Zsh syntax
- `make test` - Run smoke tests

To skip hooks temporarily: `git commit --no-verify`

---

## Conventions

- Prefer **Makefile targets** over ad-hoc scripts/commands
- Keep `install.sh` as single source of truth for symlink/backup behavior
- Follow existing patterns rather than introducing new frameworks

---

## Change Checklist

1. **New config files**: Wire symlink lifecycle in `install.sh` (install + uninstall + restore)
2. **User-facing changes**: Update `README.md` and `IMPROVEMENTS.md`
3. **Before finishing**: Run `make lint` and `make test`
