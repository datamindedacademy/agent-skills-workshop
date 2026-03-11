# Solution: PR Review Skill

## Why these choices

**Description:** "Reviews staged code changes and provides structured feedback on quality, bugs, style, and security." — This is specific enough that Claude triggers it when someone asks for a code review, but not so narrow it only works for one scenario.

**`!`git diff --cached``:** This injects only staged changes, not the entire repo. `git diff` alone would show unstaged changes. `git diff HEAD` would include both. `--cached` gives you exactly what's about to be committed — which is what you want to review.

**Four categories:** Telling Claude "review this code" produces meandering feedback. Explicit categories (correctness, security, style, performance) force structured analysis. Claude checks each one methodically instead of just eyeballing.

**Table format:** A severity/file/line/issue table is scannable. Without this, Claude writes paragraphs. Paragraphs are harder to act on than a table you can work through row by row.

**Verdict:** APPROVE/REQUEST CHANGES forces a binary decision. Without it, reviews tend to be wishy-washy.
