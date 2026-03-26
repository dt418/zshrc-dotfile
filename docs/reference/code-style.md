# Code Style Guidelines

This document outlines the coding conventions and guidelines for contributing to the dotfiles project.

## Zsh Script Conventions

### Shebang
- **Zsh scripts**: `#!/usr/bin/env zsh`
- **Bash scripts**: `#!/usr/bin/env bash`

### Error Handling
- **Test scripts**: `set -euo pipefail`
- **Install.sh and similar**: `set -e`
- **Regular functions**: Use defensive programming practices

### Strict Mode
Enable strict mode in all new Zsh scripts to catch errors early.

## File Organization

### Entry Points
- **zsh/zshrc**: Minimal entry point that only sources modules (contains no logic)
- **zsh/.zshenv**: Minimal core exports; avoid heavy `source`/`eval` operations

### Module Placement
- New shared behavior → `zsh/config/*.zsh` modules by responsibility
- Machine-specific overrides → `local.zsh` (never committed to version control)

## Guarded Optional Integrations

All optional tool/plugin integrations MUST be guarded to prevent errors when tools aren't installed:

### Command Check
```zsh
if command -v toolname >/dev/null 2>&1; then
    eval "$(toolname init zsh)"
fi
```

### File Check
```zsh
[[ -f "$path/to/config" ]] && source "$path/to/config"
```

### Non-empty File Check
```zsh
[[ -s "$path/to/file" ]] && eval "$(cat "$path/to/file")"
```

## Load Order Constraints

- `local.zsh` must stay **last** (to override previous settings)
- Syntax highlighting must be loaded at the end of `plugins.zsh`
- Preserve the established module load order in `zsh/zshrc`

## Aliases Style

Use clear section headers and group by category:

```zsh
# =========================
# GIT
# =========================
alias g="git"
alias gs="git status"
alias gcm="git checkout main"

# =========================
# NAVIGATION
# =========================
alias ..="cd .."
alias ...="cd ../.."
alias ls="eza --icons"
alias ll="ls -l"
alias la="ls -la"

# =========================
# TOOL REPLACEMENTS
# =========================
alias cat="bat"
alias find="fd"
alias grep="rg"
```

### Guidelines:
- Use section headers with `=======================`
- Group related aliases logically (by tool, function, etc.)
- Add blank lines between sections
- Prefer modern tool replacements when available
- Keep aliases simple and focused

## Functions Style

Use this format for all functions:

```zsh
function_name() {
  local arg1="$1"
  local arg2="${2:-default}"
  # implementation
}
```

### Guidelines:
- Use `function_name() {}` format (not `function function_name {}`)
- Declare variables as `local` when they don't need to escape the function
- Provide sensible defaults using `${param:-default}` for optional parameters
- Quote variable expansions to prevent word splitting and globbing
- Keep functions focused on a single responsibility
- Add comments for complex or non-obvious logic
- Handle edge cases appropriately (empty arguments, missing files, etc.)

## Section Headers

Use this format for all section headers:

```zsh
# =========================
# SECTION NAME
# =========================
```

### Guidelines:
- Use exactly 25 equals signs on each side
- Put the section name in uppercase
- Leave a blank line before and after the header when possible
- Use consistent spacing

## Examples

### Well-Formatted Alias Section
```zsh
# =========================
# DEVELOPMENT
# =========================
alias nb="npm run build"
alias nd="npm run dev"
alias nt="npm test"
alias nrs="npm run start"
alias nrw="npm run watch"
```

### Well-Formatted Function
```zsh
# Update all package managers
update_all() {
  local updated=false
  
  # Update npm packages
  if command -v npm >/dev/null 2>&1; then
    echo "Updating npm packages..."
    npm update -g && updated=true
  fi
  
  # Update Homebrew packages
  if command -v brew >/dev/null 2>&1; then
    echo "Updating Homebrew..."
    brew update && brew upgrade && updated=true
  fi
  
  # Update Rust tools
  if command -v rustup >/dev/null 2>&1; then
    echo "Updating Rust toolchain..."
    rustup update && updated=true
  fi
  
  if $updated; then
    echo "All updates completed!"
  else
    echo "No package managers found to update."
  fi
}
```

## Things to Avoid

### In Aliases:
- Don't create aliases that shadow critical system commands without good reason
- Don't make aliases overly complex (consider a function instead)
- Don't forget to test new aliases
- Don't add aliases without checking if similar functionality exists

### In Functions:
- Don't use global variables unless absolutely necessary
- Don't forget to quote variable expansions
- Don't ignore error conditions (consider `set -euo pipefail` for critical functions)
- Don't make functions overly complex (break into smaller functions when needed)
- Don't create functions with unclear side effects

### In General:
- Don't mix logic with module sourcing in zshrc
- Don't put machine-specific settings in committed files
- Don't violate the established load order
- Don't add unguarded optional integrations
- Don't ignore existing code style patterns

## Related Documentation

- [Architecture](../reference/architecture.md) - Understanding the dotfiles structure
- [Commands](../reference/commands.md) - Available make commands for validation
- [Adding New Aliases](../how-to/add-new-alias.md) - Practical guide for contributing aliases
- [Adding New Functions](../how-to/add-new-function.md) - Practical guide for contributing functions
- [Commit Conventions](../reference/commit-conventions.md) - Guidelines for commit messages