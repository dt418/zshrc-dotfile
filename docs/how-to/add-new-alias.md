# How to Add New Aliases

> **Audience**: Developers | **Time**: 2 minutes | **Last updated**: 2025-04
> **[docs](../README.md) / how-to**

This guide walks you through adding new aliases to your dotfiles configuration and verifying they work correctly.

## When to Add an Alias

Add an alias when you find yourself repeatedly typing the same command or command sequence and want to create a shortcut.

## Step-by-Step Instructions

### 1. Choose an Appropriate Name

Select a clear, memorable name for your alias:
- Keep it short but descriptive
- Avoid conflicts with existing commands or aliases
- Follow any existing naming conventions in your alias file

### 2. Add the Alias to the Configuration File

Open `zsh/config/aliases.zsh` and add your alias in the appropriate section:

```zsh
# =========================
# YOUR CATEGORY HERE
# =========================

# Your new alias
alias name="command to run"
```

**Example:**
```zsh
# =========================
# GIT
# =========================
alias g="git"
alias gs="git status"
alias gcm="git checkout main"
```

### 3. Follow the Alias Style Guidelines

Ensure your alias follows the project's style:
- Use section headers with `=======================`
- Group related aliases by category
- Add a blank line between sections
- Modern tool preferences (e.g., `ls="eza --icons"` instead of `ls="ls --color"`)

### 4. Add a Test Assertion

Open `test/zsh_test.sh` and add a test for your new alias:

```zsh
assert_alias <alias_name>
```

**Example:**
```zsh
assert_alias gcm
```

The test function looks like this:
```zsh
assert_alias() {
  local name="$1"
  alias "$name" >/dev/null || { echo "FAIL: alias $name missing"; exit 1; }
}
```

### 5. Reload Your Configuration

After making changes, reload your Zsh configuration:

```bash
source ~/.zshrc
```

### 6. Verify the Alias Works

Test that your new alias functions as expected:

```bash
# Check that the alias is recognized
alias your_alias_name

# Test the actual functionality
your_alias_name  # Should execute the underlying command
```

### 7. Run the Test Suite

Verify your addition doesn't break anything and that your test passes:

```bash
make test
# Or to test just your alias:
make test TEST="alias your_alias_name"
```

## Best Practices

### Do:
- Place aliases in logical sections (GIT, NAVIGATION, etc.)
- Use descriptive names that indicate what the alias does
- Comment complex aliases to explain their purpose
- Test aliases thoroughly before considering them complete
- Follow existing patterns in the aliases file

### Don't:
- Create aliases that shadow important system commands without good reason
- Make aliases overly complex (consider a function instead for multi-line logic)
- Forget to add tests for new aliases
- Add aliases without checking if similar functionality already exists

## Examples

### Simple Alias
```zsh
# Navigation
alias ..="cd .."
alias ...="cd ../.."
```

### Alias with Options
```zsh
# Modern tool replacements
alias ls="eza --icons --group-directories-first"
alias cat="bat"
alias find="fd"
```

### Git Alias
```zsh
# Git workflow shortcuts
alias gs="git status"
alias gca="git commit -v"
alias gcam="git commit -am"
alias gpl="git pull"
alias gps="git push"
```

## Troubleshooting

### Alias Not Working
1. Check if you reloaded your configuration: `source ~/.zshrc`
2. Verify the alias was added correctly: `alias your_alias_name`
3. Look for syntax errors in `zsh/config/aliases.zsh`
4. Ensure you saved the file before reloading

### Test Failing
1. Check that you added the correct `assert_alias` line in `test/zsh_test.sh`
2. Verify the alias name matches exactly (including case)
3. Make sure you reloaded your configuration before running tests
4. Run `zsh -n zsh/config/aliases.zsh` to check for syntax errors

## Related Guides

- [How to Add New Functions](../how-to/add-new-function.md)
- [Code Style Guidelines](../reference/code-style.md)