# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `AGENTS.md` with comprehensive agent guidelines
- `.agents/skills/code-review/` - code review skill with reviewer template
- `.agents/skills/docs-changelog/` - changelog automation skill
- `skills/` symlinks to `.agents/skills/` for tool compatibility
- `commitlint.config.js` with conventional commits rules
- `lefthook.yml` with pre-commit (lint, test) and commit-msg hooks
- `package.json` with lefthook and commitlint dependencies
- `zsh/config/env.shared.zsh` - shared environment with lazy NVM, bun, atuin

### Changed
- `install.sh` now runs `npx lefthook install` on setup
- `.gitignore` updated with agent directories, npm artifacts, and lefthook files
- Updated `.zshenv` with proper PATH and core exports

### Fixed
- `_load_nvm` function now safely handles unset function names
- `_load_nvm` auto-detects NVM_DIR from common locations (`~/.nvm`, `~/.local/share/nvm`, `~/nvm`) for Linux/Windows
- Added lazy-load wrappers for `yarn`, `pnpm`, `bun` alongside existing `nvm/node/npm/npx`
- Commit message format enforced via commitlint (lowercase header)

## [1.0.0] - 2024-01-01

### Added
- Modular Zsh dotfiles with symlink installer
- `zsh/.zshenv` for core environment variables
- Managed Starship config at `starship/starship.toml`
- Smoke test script `test/zsh_test.sh`
- Repository guidance file `AGENT.md`

### Changed
- `install.sh` supports install/uninstall/restore workflow
- `zsh/config/env.zsh` keeps runtime init only
- `make lint` validates all .zsh files
- Documentation reflects current architecture
