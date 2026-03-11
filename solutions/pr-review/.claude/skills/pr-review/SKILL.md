---
name: pr-review
description: "Reviews staged code changes and provides structured feedback on quality, bugs, style, and security."
---

# PR Review

## Context

Here are the staged changes to review:

!`git diff --cached`

## Instructions

Review the staged changes for these categories:

1. **Correctness** — Logic errors, off-by-one mistakes, unhandled edge cases, None/null safety
2. **Security** — SQL injection, XSS, hardcoded secrets, unsafe deserialization, improper input validation
3. **Style** — Naming clarity, dead code, unused imports, magic numbers, readability
4. **Performance** — Unnecessary loops, N+1 patterns, missing indexes, inefficient data structures

Be specific. Reference exact line numbers and code snippets. Don't flag nitpicks unless there are no real issues.

## Output Format

### Summary
One paragraph: what the changes do and overall quality assessment.

### Issues

| Severity | File | Line | Issue |
|---|---|---|---|
| ... | ... | ... | ... |

Severity levels: `critical` (must fix), `warning` (should fix), `info` (nice to fix)

### Verdict

Either **APPROVE** or **REQUEST CHANGES** with a one-line rationale.
