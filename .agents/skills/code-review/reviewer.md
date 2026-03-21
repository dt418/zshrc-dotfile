# Code Review for Dotfiles

You are reviewing Zsh dotfiles changes for quality and correctness.

## Context

This is a **modular Zsh dotfiles** repository with:
- Symlink-based installer
- Module loading system (`zsh/zshrc` sources `zsh/config/*.zsh`)
- Smoke tests for aliases and functions
- Conventional commit format

## Review Scope

Review the changes in this repository:

```bash
git status --short
git diff HEAD~1..HEAD
```

For new files, read their full contents.

## Zsh Code Review Checklist

**Syntax & Style:**
- [ ] Valid Zsh syntax (`zsh -n` passes)
- [ ] Proper shebang for scripts (`#!/usr/bin/env zsh` or `#!/usr/bin/env bash`)
- [ ] Error handling (`set -euo pipefail` for tests, `set -e` for install)
- [ ] Section headers use `# =========================` format
- [ ] Consistent indentation

**Module Organization:**
- [ ] New behavior goes in appropriate `zsh/config/*.zsh` module
- [ ] `zsh/zshrc` only sources modules (no logic)
- [ ] `zsh/.zshenv` minimal (core exports only, no heavy source/eval)
- [ ] `local.zsh` for machine-specific overrides (if applicable)

**Integrations:**
- [ ] Optional tool integrations are guarded:
  ```zsh
  if command -v toolname >/dev/null 2>&1; then
  [[ -f "$path" ]] && source "$path"
  [[ -s "$file" ]] && eval "$(cat "$file")"
  ```
- [ ] No hardcoded assumptions about tool availability

**Aliases & Functions:**
- [ ] Aliases defined in correct category section
- [ ] Functions use `local` for parameters
- [ ] Default values for optional params: `${param:-default}`
- [ ] No namespace collisions

**Testing:**
- [ ] New aliases have test assertions in `test/zsh_test.sh`
- [ ] New functions have test assertions
- [ ] Tests pass: `make test`

**Git/Commit:**
- [ ] Commit follows Conventional Commits format
- [ ] Commit message describes the change clearly

## Output Format

### Summary
[Brief overview of what changed and overall quality]

### Strengths
[What's well done? Be specific with file:line references]

### Issues

**Critical** (must fix before merge):
- [Issue description with file:line]
- [Why it matters]
- [How to fix]

**Important** (should fix):
- [Issue description]
- [Impact]
- [Fix suggestion]

**Minor** (nice to have):
- [Optional improvements]

### Recommendations
[Process or architecture improvements]

### Assessment

**Ready to merge?** Yes / No / With fixes

**Reasoning:** [1-2 sentence technical assessment]

## Critical Rules

**DO:**
- Check `zsh -n` syntax for every .zsh file
- Verify guard patterns for optional tools
- Confirm module loading order in zshrc
- Run `make test` to verify assertions

**DON'T:**
- Approve without syntax checking
- Miss missing guards for optional integrations
- Skip reviewing new test assertions
- Approve changes that break existing tests
