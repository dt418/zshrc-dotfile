---
name: changelog-update
description: Update CHANGELOG.md with recent commits following Keep a Changelog format
---

# Changelog Update

## When to Use

- Before releasing a new version
- After completing a significant change
- When committing with `feat`, `fix`, or other notable changes

## Changelog Format

This project uses [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format:

```markdown
# Changelog

## [Unreleased]

### Added
- New features

### Changed
- Changes to existing functionality

### Fixed
- Bug fixes

### Removed
- Removed features

## [1.0.0] - 2024-01-01

### Added
- Initial release
```

## Commit Type Mapping

| Commit Type | Changelog Section |
|-------------|-------------------|
| `feat`      | Added             |
| `fix`       | Fixed             |
| `refactor`  | Changed           |
| `perf`      | Changed           |
| `docs`      | (usually skipped) |
| `chore`     | (usually skipped) |
| `ci`        | (usually skipped) |

## How to Update

### 1. Get Recent Commits

```bash
git log --oneline -20
```

### 2. Categorize Changes

Group commits by type:
- **Added**: `feat`, `feat(scope)`
- **Fixed**: `fix`, `fix(scope)`
- **Changed**: `refactor`, `perf`
- **Removed**: `BREAKING CHANGE` or `!` commits

### 3. Write Entry

Add under `## [Unreleased]` > appropriate section:

```markdown
### Added
- feat(scope): description from commit message
```

### 4. Example

Before:
```markdown
## [Unreleased]

### Added
- Initial features
```

After adding `feat(hooks): add lefthook and commitlint`:
```markdown
## [Unreleased]

### Added
- Git hooks with lefthook (pre-commit lint/test, commit-msg commitlint)
- Conventional commits configuration
- Initial features

### Changed
```

## Quick Command

```bash
# View recent commits formatted for changelog
git log --oneline -10 --format="%s" | while read line; do
  echo "- $(echo $line | sed 's/^\([^:]*\)\(.*\)/\1\2/')"
done
```

## Release Checklist

1. [ ] Update all notable changes under `## [Unreleased]`
2. [ ] Move `## [Unreleased]` header to `## [X.Y.Z] - YYYY-MM-DD`
3. [ ] Add new `## [Unreleased]` header above
4. [ ] Verify formatting matches Keep a Changelog
5. [ ] Commit with message: `docs: update changelog for vX.Y.Z`
