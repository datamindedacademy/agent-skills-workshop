# Benchmark Exercise — Design

## Goal

Participants prove that a well-designed skill reduces token usage for a coding task. They run the same task twice (without skill, with skill), measure tokens via ccusage, and compare.

## Tool

**ccusage** (`npx ccusage@latest`) — parses Claude Code's local JSONL session logs. No infra, no Docker, no config.

## Exercise flow

### 1. Setup
- Install ccusage: `npm install -g ccusage` (or use `npx`)
- Pick a coding task from `tasks/` (we provide 2-3 pre-made tasks)
- Read the task description

### 2. Run A — No skill (baseline)
- Start a fresh Claude Code session
- Paste the task as a raw prompt (no skill, no CLAUDE.md guidance)
- Let Claude complete the task
- Note the session: `/cost`
- Exit Claude Code

### 3. Run B — With skill
- Activate the provided skill (or one the participant writes)
- Start a fresh Claude Code session
- Invoke the skill: `/refactor tasks/task-1/`
- Let Claude complete the task
- Note the session: `/cost`
- Exit Claude Code

### 4. Measure
```bash
npx ccusage session --json > results.json
```
- Extract the two most recent sessions
- Compare: input tokens, output tokens, total tokens, cost

### 5. Analyze
- Fill in a comparison table (provided as template)
- Answer: Did the skill reduce tokens? By how much? Did output quality change?
- Bonus: inspect `/context` during each run — how much of the window did the skill use?

## What we provide

### Tasks
2-3 small, self-contained coding tasks with clear success criteria:
- **Task 1: Refactor** — messy Python API → clean error handling, proper patterns
- **Task 2: Bug fix** — code with a known bug + failing test → make it pass
- Each task has: source code, requirements, expected outcome (tests or spec)

### Skill (solution)
A well-crafted skill that guides Claude through the refactoring/bugfix:
- Coding conventions to follow
- Step-by-step approach
- Error handling patterns
- Output format expectations

### Comparison script
Simple script (Python or bash) that:
- Reads ccusage JSON output
- Extracts the last N sessions
- Prints a side-by-side comparison table

### Template
Markdown template for participants to fill in their findings.

## Key learning outcomes

1. Skills reduce token usage by giving Claude focused context instead of letting it explore broadly
2. `/cost` and `/context` are built-in ways to see what's happening
3. ccusage gives post-hoc session-level data for comparison
4. The trade-off: a skill adds upfront tokens (the skill itself) but saves downstream tokens (fewer tool calls, less exploration)

## Open questions

- How reproducible are results? LLM output varies. Do we need multiple runs?
- Should we provide the skill, or have participants write one and measure their own?
- Task difficulty: too easy = no difference, too hard = too much variance
- Do we need a "quality check" beyond token counts? (tests passing = sufficient?)
