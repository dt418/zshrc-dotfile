# 🚀 Dotfiles Improvement Proposals

List of improvements split into **completed** and **proposed next**.

---

## ✅ Completed

- [x] Split `.zshrc` into functional modules
- [x] `install.sh` creates symlinks with automatic backup
- [x] `install.sh --uninstall` for clean removal
- [x] Guard clauses in `plugins.zsh` — no crash if tool not installed
- [x] `local.zsh` — per-machine overrides, not committed
- [x] `.gitignore` to prevent committing sensitive files
- [x] Split core env to `~/.zshenv` so non-interactive shells have full `PATH`, `BUN_INSTALL`, `NVM_DIR`
- [x] `install.sh` manages `~/.zshenv` symlink on install/uninstall/restore
- [x] `make lint` checks `zsh/.zshenv` too
- [x] Added smoke test `test/zsh_test.sh` + `make test`
- [x] Support single test: `make test TEST="alias <name>"`
- [x] Manage `starship/starship.toml` in repo and symlink to `~/.config/starship.toml`
- [x] Auto-repair history runs detached, avoids `jobs SIGHUPed` warning
- [x] Added TUI menu in `install.sh --menu` (prefers `fzf`, falls back to `select`)
- [x] Git hooks with lefthook (pre-commit lint/test, commit-msg commitlint)
- [x] Code review skill and changelog automation skill for agents
- [x] `AGENTS.md` with comprehensive guidelines for AI agents

---

## 🔜 Next Proposals

### 1. Lazy loading NVM

Applied in `zsh/config/env.zsh`.

---

### 2. Measure startup speed ✅

```bash
make bench
# runs: for i in $(seq 1 5); do time zsh -i -c exit; done
```

---

### 3. Extended `Makefile` ✅

Already has: `lint`, `test`, `update`, `doctor`, `bench`, `menu`, `chezmoi-install`, `chezmoi-init`, `chezmoi-apply`.

---

### 4. `doctor.sh` — check missing tools ✅

Available via `./install.sh --doctor` and `make doctor`.

---

### 5. macOS / Linux auto-support ✅

Implemented:
- `env.zsh` as OS-detecting entrypoint
- `env.shared.zsh` holds shared logic
- `env.macos.zsh` and `env.linux.zsh` hold per-OS setup

---

### 6. `chezmoi` integration (long-term)

Added basic support in `Makefile` to install/init/apply with [chezmoi](https://www.chezmoi.io/) without changing repo structure.

---

## 📊 Priority Summary

| # | Improvement | Priority | Effort |
|---|---|---|---|
| 6 | chezmoi | 🟡 Medium | High |
| 7 | Zsh plugin manager (zinit/zplugin) | 🟡 Medium | High |
