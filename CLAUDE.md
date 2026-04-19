# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

| Task | Make target | Example |
| ---- | ----------- | ------- |
| Install dotfiles | `make install` | `make install` |
| Uninstall | `make uninstall` | `make uninstall` |
| Update to latest | `make update` | `make update` |
| Run all smoke tests | `make test` | `make test` |
| Run a single test | `make test TEST="<label>"` | `make test TEST="alias ls"` |
| Lint zsh syntax | `make lint` | `make lint` |
| Check dependencies | `make doctor` | `make doctor` |
| View menu | `make menu` | `make menu` |
| Measure shell startup | `make bench` | `make bench` |

## High‑Level Architecture

- **Installation** – `install.sh` installs, uninstalls, runs a lightweight TUI menu, and checks the environment.
- **Makefile** – Provides ergonomic shortcuts for the common commands above and hooks for chezmoi.
- **zsh/** – Core dotfile layout.
  - `zsh/.zshenv` is loaded in all shell modes and only sets essential env variables.
  - `zsh/zshrc` is the interactive entry point; it sources modules in a fixed order.
  - `zsh/config/` contains separate modules:
    - `env.*.zsh` – Operating‑system specific environment setup.
    - `options.zsh` – zsh options and HISTSIZE.
    - `completion.zsh` – compinit and driver completions.
    - `plugins.zsh` – fzf, zoxide, starship, atuin, etc.
    - `aliases.zsh` – modern CLI aliases.
    - `functions.zsh` – custom helper functions.
    - `keybindings.zsh` – bindkey definitions.
    - `history‑auto‑repair.zsh` – auto‑repair corrupted history.
    - `local.zsh` – machine‑specific overrides (non‑tracked).
  - Modules are sourced in `zsh/zshrc` in the exact order shown in `docs/reference/architecture.md`.
- **Testing** – `test/zsh_test.sh` runs smoke tests asserting that expected aliases and functions are defined.
- **Tools** – `install.sh` can autoregister CLI tools (e.g., eza, bat, ripgrep) and plugins via `--plugins` / `--tools`.

## Usage Tips

- For quick reload after changes, use `reload` (alias for `source ~/.zshrc`).
- Use `make test TEST="<alias|function>"` when building a new feature.
- If you modify alias or function definitions, run `make lint` and `make test` before committing.
- The TUI menu (`make menu`) offers a visual interface when fzf is available.
- Easily integrate chezmoi: `make chezmoi-install`, `make chezmoi-init`, `make chezmoi-apply`.

## Documentation Links

- [Architecture](docs/reference/architecture.md)
- [Code Style](docs/reference/code-style.md)
- [Commands](docs/reference/commands.md)
- [Adding New Aliases](docs/how-to/add-new-alias.md)
- [Adding New Functions](docs/how-to/add-new-function.md)
- [Getting Started](docs/tutorials/getting-started.md)

---

Feel free to edit this file with new commands or architectural notes as the project evolves.

<!-- code-review-graph MCP tools -->
## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
|------|----------|
| `detect_changes` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context` | Need source snippets for review — token-efficient |
| `get_impact_radius` | Understanding blast radius of a change |
| `get_affected_flows` | Finding which execution paths are impacted |
| `query_graph` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes` | Finding functions/classes by name or keyword |
| `get_architecture_overview` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.
