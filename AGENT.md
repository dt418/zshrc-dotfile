# AGENT

## Project context
- This repository manages modular Zsh dotfiles.
- Main install flow is `./install.sh` (also exposed via `make install`).
- `zsh/zshrc` should remain a thin entrypoint that only sources modules.

## Core architecture rules
- Keep core env exports in `zsh/.zshenv` only (`PATH`, `BUN_INSTALL`, `NVM_DIR`).
- Keep `zsh/config/env.zsh` for interactive/runtime init (`source`/`eval`, lazy wrappers).
- Optional tool/plugin integration must be guarded (`command -v`, `[ -f ... ]`, `[ -s ... ]`).
- Preserve module load order in `zsh/zshrc`; `local.zsh` must stay last.

## Operational commands
- Install: `make install`
- Uninstall: `make uninstall`
- Lint: `make lint`
- Test: `make test`
- Single alias check: `make test TEST="alias ls"`
- Environment doctor: `make doctor`

## Change checklist
1. If adding new shared config file, wire symlink lifecycle in `install.sh` (install + uninstall + restore).
2. If changing user-facing behavior, update `README.md` and `IMPROVEMENTS.md`.
3. If changing workflow commands, update `.github/copilot-instructions.md`.
4. Validate with `make lint` and `make test` before finishing.
