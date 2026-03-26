# Dotfiles Architecture

This document explains the structure and organization of the dotfiles system.

## Directory Structure

```
dotfiles/
├── install.sh              # Lifecycle manager (install/uninstall/doctor/menu)
├── Makefile                # Shortcut targets
├── test/zsh_test.sh        # Smoke tests for aliases/functions
├── starship/starship.toml  # Prompt config → ~/.config/starship.toml
├── lefthook.yml           # Git hooks configuration
├── commitlint.config.js    # Commit message linting
└── zsh/
    ├── .zshenv             # Core env (all modes, interactive + non-interactive)
    ├── zshrc               # Entry point (sources modules only, no logic)
    └── config/
        ├── env.zsh              # Entrypoint env, OS detection
        ├── env.shared.zsh        # Shared runtime: bun hook, lazy NVM, atuin, envman
        ├── env.linux.zsh         # Linux-specific env
        ├── env.macos.zsh         # macOS-specific env
        ├── options.zsh           # Shell/history options
        ├── completion.zsh        # compinit, completion styles
        ├── plugins.zsh           # fzf, zoxide, starship, plugins
        ├── aliases.zsh           # User aliases
        ├── functions.zsh         # User functions
        ├── keybindings.zsh       # bindkey configurations
        ├── history-auto-repair.zsh
        └── local.zsh             # Machine-specific overrides (NOT committed)
```

## Module Loading Order

Modules are sourced in `zsh/zshrc` in this specific order:

```
env.zsh → options.zsh → completion.zsh → plugins.zsh → 
aliases.zsh → functions.zsh → keybindings.zsh → 
history-auto-repair.zsh → local.zsh
```

### Why This Order Matters

1. **env.zsh** - Sets up environment variables and PATH (foundational)
2. **options.zsh** - Configures shell behavior (needs environment set)
3. **completion.zsh** - Initializes completion system (depends on shell options)
4. **plugins.zsh** - Loads plugins like fzf, zoxide, starship (may depend on completions)
5. **aliases.zsh** - Defines aliases (may use plugins)
6. **functions.zsh** - Defines functions (may use aliases)
7. **keybindings.zsh** - Sets up custom key bindings (may use functions)
8. **history-auto-repair.zsh** - Maintains history (should run after shell is configured)
9. **local.zsh** - Machine-specific overrides (must be last to take precedence)

## Design Principles

### Modularity
- Each file has a single, well-defined responsibility
- Easy to enable/disable features by commenting out source lines
- Simple to understand and modify individual components

### Portability
- OS-specific configurations are separated (env.linux.zsh, env.macos.zsh)
- Core environment works across platforms
- Machine-specific settings never committed to version control

### Safety
- All optional integrations are guarded with command/file checks
- Defensive programming prevents errors from missing tools
- Installation process backs up existing files

### Maintainability
- Clear naming conventions make purpose obvious
- Consistent code style reduces cognitive load
- Well-documented guidelines for contributions

## Special Files

### .zshenv
- Loaded in ALL shell modes (interactive, non-interactive, login, etc.)
- Should contain only essential environment exports
- Avoids expensive operations that would slow down non-interactive shells

### zshrc
- Entry point for interactive shells
- Contains ONLY source statements for modules
- No logic or executable code (except potential error handling)

### local.zsh
- Intended for machine-specific overrides
- Excluded from version control via .gitignore
- Loaded last to allow overriding any previous settings

## Extension Guidelines

When adding new functionality:

1. **Determine the appropriate category**: env, options, completion, plugins, aliases, functions, or keybindings
2. **Create or update the relevant file** in `zsh/config/`
3. **Follow existing code style** and conventions
4. **Guard optional integrations** with command/file checks
5. **Add tests** for new aliases or functions
6. **Update documentation** as needed

## Related Documentation

- [Code Style Guidelines](../reference/code-style.md) - Detailed coding conventions
- [Commands](../reference/commands.md) - Available make commands and usage
- [Getting Started](../tutorials/getting-started.md) - Initial setup instructions
- [Design Principles](../explanation/design-principles.md) - Why architectural decisions were made