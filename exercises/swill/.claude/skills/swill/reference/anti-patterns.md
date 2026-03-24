# Skill Anti-Patterns Catalog

Common mistakes when writing Claude Code skills, and why they fail.

## 1. The Vague Description

**Bad**: `"Helps with stuff related to code and things"`
**Why it fails**: Claude uses the `description` to decide when to trigger. A vague description either triggers on everything (annoying) or gets out-competed by other skills that match better (useless).
**Fix**: Be specific about the intent. "Summarizes a git repository's recent activity, branches, contributors, and health indicators."

## 2. No Context Injection

**Bad**: Providing no `!`command`` blocks — the skill has zero context.
**Why it fails**: Without injected context, Claude has to explore the repo itself. This burns tokens, takes time, and produces inconsistent results depending on what Claude decides to look at.
**Fix**: Use `!`git log --oneline -20`` and similar commands to inject exactly the data Claude needs at invocation time.

## 3. Vague Instructions

**Bad**: `"Summarize the repo."`
**Why it fails**: Claude doesn't know what "summarize" means to you. Should it read every file? Count lines of code? Analyze test coverage? Each invocation will do something different.
**Fix**: Enumerate exactly what to analyze and how. "Count commits per author. List branches with their last commit date. Flag branches with no commits in 30 days as stale."

## 4. No Output Format

**Bad**: No `## Output Format` section.
**Why it fails**: Without a defined format, Claude improvises. One run gives you bullet points, the next a paragraph, the next a numbered list. Users can't build muscle memory or parse the output reliably.
**Fix**: Define exact sections and use tables. "Start with a one-line overview. Then a table of recent commits. Then a table of branches."

## 5. Unrestricted Tool Access

**Bad**: No `allowed-tools` in frontmatter.
**Why it fails**: Claude has access to every tool — Edit, Write, Agent, WebSearch, etc. A read-only summary skill might start editing files, spawning subagents, or making web requests. The blast radius is unbounded.
**Fix**: Set `allowed-tools: "Bash, Read"` — only what the skill actually needs.

## Summary Table

| # | Anti-Pattern | Symptom | Fix |
|---|---|---|---|
| 1 | Vague description | Triggers on wrong inputs or never at all | Match the user's intent precisely |
| 2 | No context injection | Slow, expensive, inconsistent exploration | `!`command`` injects data at invocation |
| 3 | Vague instructions | Different output every run | Specific, enumerated analysis steps |
| 4 | No output format | Unparseable walls of text | Defined sections and tables |
| 5 | Unrestricted tools | Agent wanders, edits files, makes requests | `allowed-tools` in frontmatter |
