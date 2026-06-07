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
| `description` | Yes | Claude reads this to decide when to trigger: get it right |
| `allowed-tools` | No | Tools the skill may use without asking permission |
| `model` | No | Model override while the skill is active (e.g. `eu.anthropic.claude-haiku-4-5-20251001-v1:0`); session model resumes on your next prompt |
| `effort` | No | Reasoning effort while active: `low` / `medium` / `high` |
| `disable-model-invocation` | No | `true` = only you can trigger it (`/name`), Claude never auto-runs it |
| `context` | No | `fork` = run the skill in its own subagent context |

## Syntax

| Syntax | What it does |
|---|---|
| `$ARGUMENTS` | Everything after `/skill-name` |
| `$0`, `$1` | Positional args |
| `` !`command` `` | Runs command, injects output as context |
| `${CLAUDE_SKILL_DIR}` | Path to the skill's own directory |

## Bang commands (in the prompt, not in SKILL.md)

Type `! <command>` in the Claude Code prompt to run a shell command inside the
conversation: its output lands in Claude's context. It's the manual version
of the `` !`command` `` skill syntax: `!` is you injecting live context once;
the SKILL.md form does it automatically on every invocation.

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
| Skill doesn't trigger | Fix the `description`: Claude matches intent to this text |
| Wrong tools | Add `allowed-tools` to frontmatter |
| Empty dynamic context | Check that `` !`command` `` works in your terminal |
| Supporting file not found | Use `${CLAUDE_SKILL_DIR}/path`, not relative paths |

## Five rules for good skills

1. **Description is everything.** Claude decides when to use your skill based on this field alone.
2. **Less context is more.** Only include what Claude actually needs.
3. **Specify the output format.** Tables, checklists, sections: be explicit.
4. **Use dynamic context.** `` !`command` `` beats stale instructions every time.
5. **Stay under 500 lines.** Put details in supporting files.
