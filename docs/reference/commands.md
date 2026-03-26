# Available Commands

This document lists all the make commands available in the dotfiles project and explains what each one does.

## Installation & Lifecycle

### `make install`
Apply dotfiles by creating or updating symlinks for all managed files.

This command:
- Creates symlinks from the repository to your home directory
- Backs up any existing files that would be overwritten
- Configures your Zsh environment

### `make uninstall`
Remove managed symlinks and optionally restore backups.

This command:
- Removes all symlinks created by `make install`
- Can restore backed up files if they exist
- Leaves your local.zsh file intact

### `make update`
Update your dotfiles to the latest version.

This command:
- Performs a `git pull` to get the latest changes
- Sources your ~/.zshrc to apply changes immediately
- Equivalent to running `git pull && source ~/.zshrc`

## Linting & Testing

### `make lint`
Validate Zsh syntax for all .zsh files.

This command:
- Runs `zsh -n` on all .zsh files in the zsh/ directory
- Reports any syntax errors
- Helps catch issues before they cause problems

### `make test`
Run all smoke tests for aliases and functions.

This command:
- Executes the test/zsh_test.sh script
- Verifies that all expected aliases and functions are defined
- Reports any missing or incorrect definitions

### `make test TEST="<specific_test>"`
Run a single specific test.

Examples:
- `make test TEST="alias ls"` - Test only the ls alias
- `make test TEST="assert_function fsearch"` - Test only the fsearch function

## Diagnostics

### `make doctor`
Check for required external tools.

This command:
- Verifies that all recommended tools are installed
- Reports any missing dependencies
- Helps ensure your environment is properly configured

### `make bench`
Measure shell startup time.

This command:
- Times how long it takes for your shell to start
- Runs the test 5 times for accuracy
- Reports average startup time
- Helps identify performance bottlenecks

### `make menu`
Launch an interactive TUI menu.

This command:
- Provides a text-based interface for common operations
- Allows you to run commands through a menu system
- Useful for those who prefer graphical interaction

## Development

While not explicitly called out in the Makefile, these additional commands may be useful:

### `make lint-docs`
Validate documentation (if implemented)

### `make spellcheck`
Check spelling in documentation (if implemented)

## Command Categories

Commands are grouped by their primary purpose:

**Setup & Maintenance**: install, uninstall, update
**Quality Assurance**: lint, test
**System Checks**: doctor, bench
**User Interface**: menu

## Usage Tips

1. **Always run `make lint` and `make test`** before considering changes complete
2. **Use `make update` regularly** to keep your dotfiles current
3. **Run `make doctor`** if you encounter issues with missing tools
4. **Use specific tests** when developing new features to save time

## Related Documentation

- [Architecture](../reference/architecture.md) - Understand how the dotfiles are structured
- [Code Style](../reference/code-style.md) - Learn the coding conventions
- [Getting Started](../tutorials/getting-started.md) - For initial setup instructions
- [Adding New Aliases](../how-to/add-new-alias.md) - How to contribute new aliases
- [Adding New Functions](../how-to/add-new-function.md) - How to contribute new functions