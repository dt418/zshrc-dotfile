# Commit Message Conventions

This document explains the commit message format used in this project, which follows the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Components

#### Type
Must be one of the following:

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `test` | Adding missing tests or correcting existing tests |
| `chore` | Changes to the build process or auxiliary tools |

#### Scope
Optional. Provides additional context about what part of the codebase is affected.

Examples:
- `feat(aliases): add docker compose alias`
- `fix(functions): handle empty pattern in fsearch`
- `docs: update README with new aliases`
- `refactor(config): simplify env loading`
- `test: add test for new backup function`
- `chore: update dependencies`

#### Description
A short description of the change in imperative mood (e.g., "add" not "added" or "adding").

Examples:
- `add docker compose alias`
- `handle empty pattern in fsearch`
- `update README with new aliases`
- `simplify env loading`

#### Body
Optional. Provides more detailed information about the change. Should explain the motivation for the change and contrast with previous behavior.

#### Footer
Optional. Used for referencing issues or documenting breaking changes.

Examples:
- `Fixes #123`
- `Breaking change: remove deprecated function`

## Examples

### Feature
```
feat(aliases): add docker compose alias

Add alias dcup for 'docker compose up' and dcdn for 'docker compose down'
```

### Fix
```
fix(functions): handle empty pattern in fsearch

Previously, calling fsearch without arguments would cause grep to wait for stdin input.
Now it defaults to matching all lines when no pattern is provided.
```

### Documentation
```
docs: update README with new aliases

Document the newly added git and navigation aliases in the README
```

### Refactor
```
refactor(config): simplify env loading

Replace complex conditional logic with simpler guarded approach for loading environment files
```

### Test
```
test: add test for new backup function

Add assertion to verify that backup function properly handles missing files
```

### Chore
```
chore: update dependencies

Update npm packages to latest versions and remove unused dependencies
```

## Best Practices

### Do:
- Use imperative mood in the description ("add" not "added")
- Keep the description line under 50 characters when possible
- Explain the motivation for changes in the body
- Reference related issues or pull requests in the footer
- Keep scopes meaningful and consistent
- Use only the defined types

### Don't:
- Use past tense ("added" instead of "add")
- Write overly long description lines (try to keep under 72 characters)
- Include implementation details in the description (save those for the body)
- Use vague scopes like "stuff" or "various"
- Mix multiple types in a single commit (split into separate commits if needed)

## Tools

This project uses commitlint to enforce conventional commits. To check your commit message locally:

```bash
# Install commitlint CLI (if not already installed)
npm install -g @commitlint/cli @commitlint/config-conventional

# Check a commit message
echo "feat(aliases): add new git alias" | npx --no-install commitlint
```

The pre-commit hook automatically runs commitlint to ensure all commits follow this format.

## Related Documentation

- [Code Style Guidelines](../reference/code-style.md) - Coding conventions for the project
- [Commands](../reference/commands.md) - Available make commands including test and lint
- [Architecture](../reference/architecture.md) - Understanding the dotfiles structure