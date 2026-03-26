# Getting Started with Dotfiles

This guide will help you install and configure the modular Zsh dotfiles system.

## Prerequisites

Before you begin, ensure you have:

- A Unix-like operating system (Linux or macOS)
- Zsh shell installed
- Git installed for version control
- Basic familiarity with terminal commands

## Installation

Follow these steps to install the dotfiles:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### 2. Run the Installation Script

```bash
make install
```

This will:
- Create symlinks for all managed files in your home directory
- Back up any existing files that would be overwritten
- Configure your Zsh environment

### 3. Restart Your Shell

After installation, either:
- Restart your terminal application
- Or run: `source ~/.zshrc`

## Verification

To verify the installation worked correctly:

```bash
# Check that key aliases are available
alias g
alias ls

# Check that key functions are available
typeset -f fsearch

# Run the built-in tests
make test
```

## Configuration

### Personal Overrides

Machine-specific settings should be placed in `~/.zsh/local.zsh` (this file is not tracked by git).

### Available Customization Points

The dotfiles system is organized into modules:
- `env.zsh` - Environment variables and PATH setup
- `options.zsh` - Shell options and history configuration
- `completion.zsh` - Completion system initialization
- `plugins.zsh` - Plugin management (fzf, zoxide, starship, etc.)
- `aliases.zsh` - Custom shell aliases
- `functions.zsh` - Custom shell functions
- `keybindings.zsh` - Custom key bindings
- `history-auto-repair.zsh` - History maintenance
- `local.zsh` - Your personal overrides

## Next Steps

After getting the basics working, you might want to:

- Explore the [how-to guides](../how-to/) for specific tasks
- Review the [reference materials](../reference/) for detailed information
- Check out the [design principles](../explanation/design-principles.md) to understand why things are structured this way

## Troubleshooting

If you encounter issues:

1. **Symlink problems**: Run `make uninstall` followed by `make install`
2. **Zsh errors**: Check `~/.zshenv` and `~/.zshrc` for syntax errors
3. **Missing commands**: Ensure required tools are installed (see `make doctor`)
4. **Test failures**: Run `make test` to see what's failing

For more help, consult the [reference documentation](../reference/).