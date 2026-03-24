---
name: swill
# This description is intentionally broken — it's anti-pattern #1.
# TODO 1: Rewrite this description so it only triggers for repo summary requests.
# Hint: The current description is so vague it would match almost any user message.
description: "Helps with stuff related to code and things"
# This is intentionally missing — anti-pattern #5.
# TODO 5: Add allowed-tools to restrict Claude to only what it needs (Bash, Read).
---

# Repo Summary

## Context

<!-- This section is intentionally empty — anti-pattern #2. -->
<!-- The skill provides ZERO context. Claude has to explore the repo from scratch every time. -->
<!-- TODO 2: Inject dynamic context using !`command` syntax. -->
<!-- Think about what git commands give you: -->
<!--   - Recent commit history (git log --oneline -20) -->
<!--   - Active branches (git branch -a) -->
<!--   - Current status (git status --short) -->
<!--   - Contributors (git shortlog -sn) -->

## Instructions

<!-- This is intentionally vague — anti-pattern #3. -->
<!-- TODO 3: Replace this with specific, actionable instructions. -->
<!-- Think about: -->
<!--   - What exactly should Claude analyze? -->
<!--   - How should it interpret commit frequency and recency? -->
<!--   - What counts as "active" vs "stale" branches? -->
<!--   - How should it assess repo health? -->
Summarize the repo.

## Output Format

<!-- There is intentionally no output format — anti-pattern #4. -->
<!-- TODO 4: Define a consistent output structure. -->
<!-- Consider sections like: -->
<!--   - Overview (one-line summary of the repo's purpose) -->
<!--   - Recent activity (table of last N commits) -->
<!--   - Branch status (table: branch, last commit date, ahead/behind) -->
<!--   - Top contributors (table: name, commit count) -->
<!--   - Health indicators (uncommitted changes, stale branches, etc.) -->
