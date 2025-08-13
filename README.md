# Git Key Guardian

A lightweight Git pre-commit hook that scans staged changes for common secret patterns and your own personal keys. It helps you catch accidental commits of API keys and credentials before they land in your repository.

## Install

Copy-paste to install globally:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/your-org/git-key-guardian/main/scripts/install.sh)"
```

Or install from a local clone:

```bash
./scripts/install.sh
```

This sets a global hooks path at `$HOME/.git-key-guardian/hooks` and places the `pre-commit` hook there.

## Usage

- Stage your changes normally.
- On `git commit`, the hook scans only the staged changes for:
  - Matches to repo-maintained regex rules in `patterns/common_patterns.txt`
  - Fixed-string matches to any entries in `$HOME/.git-key-guardian/personal_keys.txt`
- If a match is found, you'll be shown sample lines and asked to confirm before continuing.

## Adding Keys

Append your personal secrets to track (exact string matches) in:

```
$HOME/.git-key-guardian/personal_keys.txt
```

Lines starting with `#` and empty lines are ignored.

## Updating Patterns

Update or add regex lines in:

```
patterns/common_patterns.txt
```

- One regex per line.
- Inline comments are allowed after whitespace `#`.
- Keep expressions efficient and avoid catastrophic backtracking.

## Contributing

See `CONTRIBUTING.md` for guidelines on proposing new regex patterns and test cases.

## Disclaimer

This tool is a helper, not a silver bullet. Use proper secret management, rotate keys regularly, and audit commits and CI logs.
