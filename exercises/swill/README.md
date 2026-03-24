# Exercise: Swill — The Anti-Skill

Learn what makes a good skill by fixing a deliberately broken one. You'll start with a "swill" (a skill gone wrong) and repair each anti-pattern one TODO at a time.

## What you'll learn

- Why `description` precision matters — too vague triggers everywhere, too narrow never fires
- Why vague instructions produce garbage — "do the thing" vs specific steps
- Why unconstrained `allowed-tools` is dangerous — the agent wanders
- Why unstructured output is useless — walls of text vs actionable tables
- Why missing context injection defeats the purpose — static skills go stale

## Prerequisites

- Completed the PR Review warm-up exercise
- Basic understanding of skill syntax (see `cheatsheet.md`)

## Directory layout

```
.claude/skills/swill/
├── SKILL.md                     # The broken skill (your exercise)
└── reference/
    └── anti-patterns.md         # Catalog of common skill anti-patterns
```

## The scenario

You've inherited a skill that's supposed to summarize the current git repository — recent commits, active branches, contributors, and repo health. It was written by someone who read zero documentation. Your job: fix it.

## Steps

### 1. Read the broken skill

Open `.claude/skills/swill/SKILL.md`. Try to invoke it:

```bash
cd exercises/swill
claude
```

```
/swill
```

Notice what goes wrong. Then read `reference/anti-patterns.md` to understand the failure modes.

### 2. TODO 1 — Fix the description

The current description is laughably broad. It would trigger on almost any user message. Rewrite it to clearly describe when this skill should activate.

**Anti-pattern**: "Helps with stuff" — tells Claude nothing.
**Fix**: Be specific about the trigger intent.

### 3. TODO 2 — Add dynamic context injection

The skill has zero context about the repo. It's flying blind. Inject the information Claude actually needs using `!`command`` syntax.

**Anti-pattern**: No context injection — Claude has to guess or explore on its own.
**Fix**: Inject `git log`, `git branch`, and other repo metadata dynamically.

### 4. TODO 3 — Replace vague instructions with specific ones

The instructions currently say "summarize the repo." That's not a skill, that's a wish. Write clear steps for what Claude should analyze and how.

**Anti-pattern**: "Just figure it out" — produces inconsistent, low-quality output.
**Fix**: Enumerate exactly what to analyze and how to interpret it.

### 5. TODO 4 — Structure the output

There's no output format defined. Claude will dump a wall of text. Define sections, tables, and a consistent structure.

**Anti-pattern**: No output specification — every invocation looks different.
**Fix**: Define exact sections and formats.

### 6. TODO 5 — Constrain allowed-tools

The skill currently has access to everything. Claude might start editing files, making network requests, or running destructive commands. Lock it down.

**Anti-pattern**: Unrestricted tool access — the agent wanders and does unexpected things.
**Fix**: Only allow `Bash` and `Read`.

### 7. Test it

```bash
cd exercises/swill
claude
```

```
/swill
```

### 8. Verify

Your fixed skill should:
- Only trigger when the user asks for a repo summary
- Inject fresh git data at invocation time (not stale)
- Produce consistent, structured output every time
- Never try to edit files or do anything beyond reading and reporting
- Complete in a few seconds, not minutes of exploration

## When you're done

Compare with `solutions/swill/`. The README there explains each anti-pattern and why the fix works.
