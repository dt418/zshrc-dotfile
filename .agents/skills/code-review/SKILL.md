---
name: code-review
description: Review dotfiles changes for quality before merge
---

# Code Review

Review changes using Task tool with `general` agent and this prompt.

## Quick Start

```bash
# Run automated checks
make lint && make test

# View changes
git diff HEAD~1..HEAD
git status --short
```

## Review Checklist

**Syntax & Style:**
- `zsh -n` passes for all .zsh files
- Shebang: `#!/usr/bin/env zsh` or `#!/usr/bin/env bash`
- Section headers: `# =========================`

**Module Organization:**
- `zsh/zshrc` only sources modules (no logic)
- `zsh/.zshenv` minimal (core exports only)
- New behavior → appropriate `zsh/config/*.zsh`

**Integrations:**
- Optional tools guarded: `command -v`, `[ -f ]`, `[ -s ]`

**Testing:**
- New aliases/functions have test assertions in `test/zsh_test.sh`

**Git:**
- Commit follows: `<type>(<scope>): <description>`
- Valid types: feat, fix, docs, style, refactor, test, chore, perf, ci
- Valid scopes: aliases, functions, plugins, completion, keybindings, env, install, test, docs, hooks

## Review Prompt Template

```
# Code Review

Review the dotfiles repository changes.

1. Run: git diff HEAD~1..HEAD
2. Run: make lint && make test
3. Check:
   - Zsh syntax valid
   - Module organization correct
   - Guards for optional tools
   - Tests pass
   - Commit format valid

Output:
### Summary
[Overview]

### Issues
[Critical/Important/Minor with file:line]

### Assessment
Ready to merge? Yes/No/With fixes
```

## When to Review

- After completing feature/fix
- Before merge to main
- When stuck (fresh perspective)
