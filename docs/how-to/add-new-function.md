# How to Add New Functions

This guide walks you through adding new functions to your dotfiles configuration and verifying they work correctly.

## When to Add a Function

Add a function when you need:
- More complex logic than an alias can provide
- To accept arguments or process input
- To encapsulate reusable shell logic
- To avoid repeating multi-line command sequences

## Step-by-Step Instructions

### 1. Choose an Appropriate Name

Select a clear, descriptive name for your function:
- Use lowercase letters and underscores (snake_case)
- Make the name descriptive of what the function does
- Avoid conflicts with existing commands or functions
- Follow any existing naming conventions in your function file

### 2. Add the Function to the Configuration File

Open `zsh/config/functions.zsh` and add your function:

```zsh
function_name() {
  local arg1="$1"
  local arg2="${2:-default_value}"
  # implementation
}
```

**Example:**
```zsh
# Create a directory and change into it
mkcd() {
  mkdir -p "$1"
  cd "$1"
}
```

### 3. Follow the Function Style Guidelines

Ensure your function follows the project's style:
- Use `function_name() {}` format (not `function function_name {}`)
- Declare variables as `local` when appropriate
- Provide sensible defaults for optional parameters using `${param:-default}`
- Include comments for complex logic
- Keep functions focused on a single responsibility

### 4. Add a Test Assertion

Open `test/zsh_test.sh` and add a test for your new function:

```zsh
assert_function <function_name>
```

**Example:**
```zsh
assert_function mkcd
```

The test function looks like this:
```zsh
assert_function() {
  local name="$1"
  typeset -f "$name" >/dev/null || { echo "FAIL: function $name missing"; exit 1; }
}
```

### 5. Reload Your Configuration

After making changes, reload your Zsh configuration:

```bash
source ~/.zshrc
```

### 6. Verify the Function Works

Test that your new function functions as expected:

```bash
# Check that the function is recognized
typeset -f your_function_name

# Test the actual functionality with various inputs
your_function_name arg1 arg2
```

### 7. Run the Test Suite

Verify your addition doesn't break anything and that your test passes:

```bash
make test
# Or to test just your function:
make test TEST="assert_function your_function_name"
```

## Best Practices

### Do:
- Keep functions small and focused on a single task
- Use `local` for variables that don't need to escape the function
- Quote variable expansions to prevent word splitting and globbing
- Provide sensible defaults for optional parameters
- Handle edge cases (empty arguments, missing files, etc.)
- Add comments explaining non-obvious logic
- Follow existing patterns in the functions file

### Don't:
- Use global variables unless absolutely necessary
- Forget to quote variable expansions
- Make functions overly complex (consider breaking into smaller functions)
- Ignore error conditions (use `set -euo pipefail` in functions that need it)
- Create functions that produce side effects without clear documentation

## Examples

### Simple Function with Default Parameter
```zsh
# Search for files containing a pattern
fsearch() {
  local pattern="${1:-.*}"
  grep -r "$pattern" .
}
```

### Function with Error Handling
```zsh
# Safe file backup
backup() {
  local file="$1"
  
  [[ -z "$file" ]] && { echo "Error: No file specified"; return 1 }
  [[ ! -e "$file" ]] && { echo "Error: File '$file' does not exist"; return 1 }
  
  cp "$file" "${file}.bak_$(date +%Y%m%d_%H%M%S)"
  echo "Backed up '$file' to '${file}.bak_$(date +%Y%m%d_%H%M%S)'"
}
```

### Function That Modifies Environment
```zsh
# Add directory to PATH if it exists and isn't already there
add_to_path() {
  local dir="$1"
  
  [[ -z "$dir" ]] && { echo "Error: No directory specified"; return 1 }
  [[ ! -d "$dir" ]] && { echo "Error: '$dir' is not a directory"; return 1 }
  
  case ":$PATH:" in
    *:"$dir":*) ;; # Already in PATH
    *) export PATH="$dir:$PATH" ;;
  esac
}
```

## Advanced Patterns

### Functions That Accept Flags
```zsh
# Process files with options
process_files() {
  local recursive=false
  local verbose=false
  
  # Parse options
  while [[ $# -gt 0 ]]; do
    case $1 in
      -r|--recursive) recursive=true; shift ;;
      -v|--verbose) verbose=true; shift ;;
      *) break ;; # First non-option argument
    esac
  done
  
  local target_dir="${1:-.}"
  
  if $recursive; then
    find "$target_dir" -type f
  else
    ls "$target_dir"
  fi
}
```

### Functions With Pipelines
```zsh
# Show git branch with color
git_branch() {
  git branch --show-current 2>/dev/null | while read branch; do
    echo -e "%{$fg[green]%}$branch%{$reset_color%}"
  done
}
```

## Troubleshooting

### Function Not Working
1. Check if you reloaded your configuration: `source ~/.zshrc`
2. Verify the function was added correctly: `typeset -f your_function_name`
3. Look for syntax errors in `zsh/config/functions.zsh`
4. Ensure you saved the file before reloading
5. Check for naming conflicts with existing commands or functions

### Test Failing
1. Check that you added the correct `assert_function` line in `test/zsh_test.sh`
2. Verify the function name matches exactly (including case and underscores)
3. Make sure you reloaded your configuration before running tests
4. Run `zsh -n zsh/config/functions.zsh` to check for syntax errors

## Related Guides

- [How to Add New Aliases](../how-to/add-new-alias.md)
- [Running Tests](../how-to/run-tests.md)
- [Code Style Guidelines](../reference/code-style.md)
- [Function Style Guidelines](../reference/code-style.md#functions-style)