# Changelog

## Unreleased

### Added
- Added `zsh/.zshenv` for core environment variables shared by interactive and non-interactive Zsh sessions.
- Added managed Starship config at `starship/starship.toml` with installer symlink to `~/.config/starship.toml`.
- Added smoke test script `test/zsh_test.sh`.
- Added `make test` target, with single-check mode via `make test TEST="alias <name>"`.
- Added repository guidance file `AGENT.md`.

### Changed
- Updated `install.sh` to install/uninstall/restore `~/.zshenv` and `~/.config/starship.toml`.
- Updated `zsh/config/env.zsh` to keep runtime init only (core exports moved to `.zshenv`).
- Updated `make lint` to include `zsh/.zshenv`.
- Updated docs (`README.md`, `IMPROVEMENTS.md`, `.github/copilot-instructions.md`) to reflect current architecture and workflows.
