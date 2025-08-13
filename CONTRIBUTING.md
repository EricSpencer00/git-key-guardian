# Contributing

Thanks for helping improve Git Key Guardian! This document explains how to add and maintain regex patterns safely and efficiently.

## Goals

- Catch likely secrets with high signal-to-noise.
- Keep patterns fast and resilient (avoid catastrophic backtracking).
- Make it easy to extend without changing hook logic.

## Where to add patterns

Edit `patterns/common_patterns.txt`.

- One pattern per line.
- Use plain regex (no delimiters like `/.../`).
- You can include an inline comment by adding whitespace then `# comment...`.
- Blank lines and pure comment lines are ignored by the hook.

Example:

```
# Stripe live key
sk_live_[0-9a-zA-Z]{24}

# OpenAI API key (older format)
sk-[A-Za-z0-9]{48}
```

## Pattern design rules

- Prefer anchored subpatterns when possible (e.g., fixed prefixes like `AKIA`).
- Avoid nested, unbounded quantifiers like `(.*)+`, `(a|ab)*`, or backreferences that can explode runtime.
- Use character classes and repetition bounds, e.g., `[A-Za-z0-9]{20,}` when formats are known.
- Consider word boundaries `\b` to reduce false positives.
- Keep patterns language-agnostic (POSIX ERE compatible where possible).

## Test your patterns locally

Create a scratch file (or use `examples/`) with positive and negative cases. Then simulate a commit locally:

```bash
# Create a test repo
mkdir /tmp/gkg-test && cd /tmp/gkg-test && git init -q

# Create a file with some examples
cat > test.txt <<'EOS'
ess kay _ live_1234567890abcdefghijklmn
not_a_key AKIAABCDEFGHIJKLMNOP
ess ess ayche - arr ess ayy AAAAB3NzaC1yc2EAAAADAQABAAABAQDabc==
random text
EOS

# Stage and commit to trigger the hook
git add test.txt
GIT_DIR=.git GIT_WORK_TREE=. git commit -m "test" || true
```

You should see the hook report matches and prompt to proceed or abort.

## Submitting changes

- Update `patterns/common_patterns.txt` and include minimal examples in `examples/`.
- Explain the rationale and provide links to official formats when possible.
- Keep PRs focused and small.

## Code of conduct

Be respectful and constructive. We’re here to help protect everyone’s code.
