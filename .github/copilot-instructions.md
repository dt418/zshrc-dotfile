# Copilot Instructions for this dotfiles repository

## Build, test, and lint commands

- `make lint`
  - Validates Zsh syntax for `zsh/.zshenv`, `zsh/zshrc`, and all `zsh/config/*.zsh` modules (`zsh -n` checks).
- `make test`
  - Runs smoke tests in `test/zsh_test.sh` to verify critical aliases/functions exist in installed config.
- `make doctor`
  - Runs `./install.sh --doctor` to verify required external tools are installed.
- `make bench`
  - Runs `time zsh -i -c exit` five times to measure interactive shell startup performance.
- `make install`
  - Applies this repository to the current machine by creating/updating symlinks.
- `make uninstall`
  - Removes managed symlinks and optionally restores the latest backup.

Single-test execution:

- Run one alias check with `make test TEST="alias <name>"`.
- Example: `make test TEST="alias ls"`.

## High-level architecture

The repository is a modular Zsh configuration system with a symlink-based installer:

1. `zsh/zshrc` is the entrypoint and only orchestrates module loading order.
2. `zsh/.zshenv` defines core environment for all Zsh modes (interactive and non-interactive).
2. Runtime behavior lives in `zsh/config/*.zsh`, split by concern:
   - `env.zsh`: runtime init only (bun hook, Homebrew setup, lazy-loaded NVM wrappers, atuin/envman).
   - `options.zsh`: Zsh shell/history options and history file sizing.
   - `completion.zsh`: `compinit`, completion styles, dynamic Docker/Kubectl completion.
   - `plugins.zsh`: optional tool/plugin initialization with command/file guards.
   - `aliases.zsh`, `functions.zsh`, `keybindings.zsh`: user command surface.
   - `history-auto-repair.zsh` + `history-repair.sh`: background history corruption detection and repair flow.
3. `install.sh` is the lifecycle manager:
   - install: symlink files into `~/.config/zsh`, `~/.zshrc`, `~/.zshenv`, and `~/.config/starship.toml`.
   - uninstall: remove repo-owned symlinks (including `~/.zshenv` and starship config) and optionally restore latest backup.
   - doctor: check required tools and show install hints.
4. `local.zsh` is intentionally loaded last (if present) for machine-specific non-committed overrides.

## Key conventions

- Keep `zsh/zshrc` minimal: it should source modules, not contain logic.
- New shared behavior belongs in `zsh/config/*.zsh` modules by responsibility.
- Keep `zsh/.zshenv` minimal and fast: only core exports needed by non-interactive shells; avoid heavy `source`/`eval` there.
- Optional integrations must be guarded (`command -v`, `[ -f ... ]`, `[ -s ... ]`) so missing tools never break shell startup.
- Keep tests lightweight and shell-native; extend `test/zsh_test.sh` and `make test` rather than introducing heavy test frameworks.
- Load-order constraints matter:
  - syntax highlighting is loaded at the end of `plugins.zsh`.
  - `local.zsh` is loaded after all shared modules for override semantics.
- Performance-sensitive initializations should avoid eager loading; follow the existing lazy-wrapper pattern (e.g., NVM in `env.zsh`).
- `install.sh` is the source of truth for linking behavior; keep symlink/backup semantics centralized there.
- Prefer updating `Makefile` targets for operational workflows instead of adding ad-hoc scripts/commands in docs.
