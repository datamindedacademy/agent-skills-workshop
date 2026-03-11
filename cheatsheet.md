# Skills Cheatsheet

## What a skill looks like

```markdown
---
name: my-skill
description: "When Claude should trigger this skill"
allowed-tools: Read, Edit, Bash, Write
---

# My Skill

Instructions go here.
```

## Frontmatter

| Field | Required | What it does |
|---|---|---|
| `name` | Yes | `/name` to invoke |
| `description` | Yes | Claude reads this to decide when to trigger — get it right |
| `allowed-tools` | No | Restrict available tools |

## Syntax

| Syntax | What it does |
|---|---|
| `$ARGUMENTS` | Everything after `/skill-name` |
| `$0`, `$1` | Positional args |
| `` !`command` `` | Runs command, injects output as context |
| `${CLAUDE_SKILL_DIR}` | Path to the skill's own directory |

## Where skills live

```
.claude/skills/<skill-name>/SKILL.md    # project-level
~/.claude/skills/<skill-name>/SKILL.md  # user-level
```

## Invoking

```
/skill-name
/skill-name arg1 arg2
```

## Debugging

| Problem | Fix |
|---|---|
| Skill doesn't trigger | Fix the `description` — Claude matches intent to this text |
| Wrong tools | Add `allowed-tools` to frontmatter |
| Empty dynamic context | Check that `` !`command` `` works in your terminal |
| Supporting file not found | Use `${CLAUDE_SKILL_DIR}/path`, not relative paths |

## Five rules for good skills

1. **Description is everything.** Claude decides when to use your skill based on this field alone.
2. **Less context is more.** Only include what Claude actually needs.
3. **Specify the output format.** Tables, checklists, sections — be explicit.
4. **Use dynamic context.** `` !`command` `` beats stale instructions every time.
5. **Stay under 500 lines.** Put details in supporting files.
