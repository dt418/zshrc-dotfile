---
name: code-review
description: Use when completing tasks, implementing features, or before merging to verify changes meet requirements
---

# Code Review

Use the `reviewer.md` template to dispatch a subagent for code review.

## When to Request Review

**Mandatory:**
- After completing feature or fix
- Before merge to main
- After implementing major change

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing complex bug

## How to Request

**1. Get the diff:**
```bash
git diff HEAD~1..HEAD        # Review last commit
git diff origin/main..HEAD   # Review unmerged changes
```

**2. Dispatch `general` subagent with reviewer.md template:**

Use Task tool with `general` agent type, providing the content of `reviewer.md` as the prompt.

## What to Review

- Zsh syntax validity (`zsh -n`)
- Alias/function definitions match test assertions
- Module loading order preserved
- Guarded integrations (`command -v`, `[ -f ]`)
- Error handling patterns
- Commit message format

## Act on Feedback

- **Critical:** Fix immediately
- **Important:** Fix before proceeding
- **Minor:** Note for later
- **Feedback:** Push back if reviewer is wrong (with reasoning)

## Quick Review Commands

```bash
# Syntax check all zsh files
make lint

# Run smoke tests
make test

# Run single test
make test TEST="alias ls"

# Verify module load order
grep -n "source" zsh/zshrc
```
