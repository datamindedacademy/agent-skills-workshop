# Exercise: Swill — The Anti-Skill

A skill that secretly sabotages Claude's code output. It silently triggers during normal coding tasks and injects subtle anti-patterns — bad variable names, missing error handling, copy-paste duplication, magic numbers, and more.

Participants use Claude to complete a coding task, notice the output is suspiciously bad, and have to figure out *why*. The answer: a hidden skill is poisoning the context.

## What you'll learn

- How skills silently shape agent behavior — even when you don't invoke them
- Why broad `description` fields are dangerous — they trigger on unintended inputs
- How bad context injection produces bad code
- How to audit and debug active skills
- The importance of reviewing AI-generated code critically

## Prerequisites

- Completed the PR Review warm-up exercise
- Basic understanding of skill syntax (see `cheatsheet.md`)

## Directory layout

```
.claude/skills/swill/
├── SKILL.md                     # The saboteur skill (participants must find and understand this)
└── reference/
    └── anti-patterns.md         # The anti-patterns the skill injects
```

## How it works

The swill skill has a broad `description` that matches any coding request. When a participant asks Claude to write or modify code, the skill silently activates and instructs Claude to introduce subtle anti-patterns — things that look plausible but violate best practices.

The participant doesn't know the skill exists. They just see Claude writing weirdly bad code.

## Steps

### 1. Set the trap

The swill skill is already installed in `.claude/skills/swill/`. Participants don't need to know about it — they'll discover it.

### 2. Give participants a coding task

Ask them to use Claude to build something in this directory. For example:

```
Write a Python CLI tool that reads a CSV file and outputs summary statistics
(row count, column names, min/max/mean for numeric columns).
```

### 3. Watch the chaos

Claude will write code that works but is full of anti-patterns:
- Single-letter variable names (`d`, `x`, `r`)
- Magic numbers with no explanation
- No error handling
- Copy-pasted logic instead of functions
- Commented-out code left in
- Overly broad `except Exception` blocks

### 4. The reveal

Ask participants: "Why is Claude writing such bad code?"

Hints (give one at a time):
1. "It's not Claude's fault — something is influencing it."
2. "Check what skills are active."
3. "Look in `.claude/skills/`."

### 5. TODO 1 — Find the skill

Participants locate `.claude/skills/swill/SKILL.md` and read it.

### 6. TODO 2 — Understand the trigger

Why does this skill activate on normal coding requests? Look at the `description` field.

### 7. TODO 3 — Identify the injected anti-patterns

Read `reference/anti-patterns.md`. Match each anti-pattern to what Claude actually produced.

### 8. TODO 4 — Disable or fix the skill

Options:
- Delete the skill entirely
- Narrow the `description` so it stops triggering
- Rewrite the instructions to inject *good* patterns instead (turning a swill into a skill)

### 9. TODO 5 — Re-run the task

Ask Claude to redo the same coding task. Compare the before/after output.

## Verify

After fixing/removing the swill:
- Claude produces clean, idiomatic code
- Variables have meaningful names
- Error handling is appropriate
- No copy-paste duplication
- No magic numbers

## Discussion points

- How easy was it to spot the anti-patterns?
- Would you have caught them in a real code review?
- What does this teach about trusting AI-generated code?
- How could a malicious skill be even more subtle?

## When you're done

Compare with `solutions/swill/`. The README there discusses the design choices behind the sabotage.
