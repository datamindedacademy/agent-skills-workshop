# Exercise: PR Review Skill

Build a skill that reviews staged git changes and gives structured feedback.

## What you'll learn

- `description` field — how Claude decides when to trigger your skill
- `!`command`` — dynamic context injection
- Directing agent behavior with specific instructions
- Structured output formatting

## Steps

### 1. Read the skeleton

Open `.claude/skills/pr-review/SKILL.md`. You'll see four TODOs.

### 2. TODO 1 — Write the description

The `description` field is how Claude knows when to use your skill. Write something that clearly says "this skill reviews code changes."

### 3. TODO 2 — Inject staged changes

Use `` !`git diff --cached` `` to dynamically inject the currently staged diff. This runs at invocation time, so Claude always sees fresh changes.

### 4. TODO 3 — Define review criteria

Tell Claude what to look for. Be specific — "review this code" produces garbage. Try categories like correctness, security, style, performance.

### 5. TODO 4 — Structure the output

Define exactly what the output looks like. A summary, a table of issues with severity, and a final verdict works well.

### 6. Test it

```bash
# Create a test repo with staged changes that have bugs
./test-repo/setup.sh

# Follow the instructions it prints, then invoke your skill
/pr-review
```

### 7. Verify

Your skill should catch at least:
- The SQL injection in `app.py`
- The off-by-one error in `app.py`
- The None-handling bug in `utils.py`
- The unused import in `utils.py`

## When you're done

Compare your solution with `solutions/pr-review/`. The README there explains why each design choice was made.
