---
name: changelog-automation
description: Generate and maintain CHANGELOG.md using git-cliff for this dotfiles project
---

# Changelog Automation

Lightweight changelog management using [git-cliff](https://github.com/orhun/git-cliff).

## Quick Start

```bash
# Install git-cliff
cargo install git-cliff
# or: brew install git-cliff

# Preview unreleased changes
git cliff --unreleased --dry-run

# Generate full changelog
git cliff -o CHANGELOG.md

# Generate from specific tag
git cliff v1.0.0..HEAD -o CHANGELOG.md
```

## git-cliff Configuration

```toml
# cliff.toml
[changelog]
header = """
# Changelog

"""
footer = """
[Unreleased]: https://github.com/thanhd/dotfiles/compare/v{version}...HEAD
{version}: https://github.com/thanhd/dotfiles/compare/{previous_version}...v{version}
"""
trim = true

[git]
conventional_commits = true
commit_parsers = [
    { message = "^feat", group = "Added" },
    { message = "^fix", group = "Fixed" },
    { message = "^refactor|^perf", group = "Changed" },
    { message = "^docs", group = "Documentation", skip = true },
    { message = "^chore", group = "Maintenance", skip = true },
    { message = "^ci", group = "CI", skip = true },
]
```

## Release Process

1. Preview changes: `git cliff --unreleased --dry-run`
2. Generate: `git cliff -o CHANGELOG.md`
3. Commit: `git add CHANGELOG.md && git commit -m "docs: update changelog"`
4. Tag: `git tag v1.1.0 && git push --tags`

## Manual Update (Without git-cliff)

```bash
# View recent commits
git log --oneline -10

# Edit CHANGELOG.md manually under ## [Unreleased]
```

## Commit Types → Changelog Sections

| Commit | Section |
|--------|---------|
| `feat` | Added |
| `fix` | Fixed |
| `refactor`, `perf` | Changed |
| `docs`, `chore`, `ci` | (excluded) |
