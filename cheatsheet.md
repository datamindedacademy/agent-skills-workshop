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

## Frontmatter reference

Only `description` is really needed. Full reference:
[code.claude.com/docs/en/skills#frontmatter-reference](https://code.claude.com/docs/en/skills#frontmatter-reference)

| Field | What it does |
|---|---|
| `name` | `/name` to invoke (defaults to the folder name) |
| `description` | When Claude should trigger the skill: the most important line |
| `allowed-tools` | Tools the skill may use without asking permission |
| `disallowed-tools` | Tools removed from the pool while the skill is active |
| `model` | Model override while active (e.g. `eu.anthropic.claude-haiku-4-5-20251001-v1:0`); session model resumes next prompt. Or `inherit` |
| `effort` | Reasoning effort while active: `low` / `medium` / `high` / `xhigh` / `max` |
| `disable-model-invocation` | `true` = only you trigger it (`/name`); Claude never auto-runs it |
| `user-invocable` | `false` = hide from the `/` menu (background knowledge only) |
| `context` | `fork` = run in a forked subagent context |
| `agent` | Which subagent type to use when `context: fork` |
| `paths` | Glob(s); auto-load the skill only when working on matching files |
| `hooks` | Hooks scoped to this skill's lifecycle |
| `shell` | `bash` (default) or `powershell` for `` !`command` `` blocks |

## Syntax

| Syntax | What it does |
|---|---|
| `$ARGUMENTS` | Everything after `/skill-name` |
| `$0`, `$1` | Positional args |
| `` !`command` `` | Runs command, injects output as context |
| `${CLAUDE_SKILL_DIR}` | Path to the skill's own directory |

## Bang commands (in the prompt, not in SKILL.md)

Type `! <command>` in the Claude Code prompt to run a shell command inside the
conversation. Its output lands in Claude's context. Think of it as the manual
version of the `` !`command` `` skill syntax. With `!` you inject live context
once, by hand; in a `SKILL.md` the same line runs automatically every time the
skill is invoked.

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
| Edited the skill, but the open session still runs the old version | Run `/reload-skills` in that session (or restart `claude`) |
| Wrong tools | Add `allowed-tools` to frontmatter |
| Empty dynamic context | Check that `` !`command` `` works in your terminal |
| Supporting file not found | Use `${CLAUDE_SKILL_DIR}/path`, not relative paths |

## Five rules for good skills

1. **Description is everything.** Claude decides when to use your skill based on this field alone.
2. **Less context is more.** Only include what Claude actually needs.
3. **Specify the output format.** Tables, checklists, sections: be explicit.
4. **Use dynamic context.** `` !`command` `` beats stale instructions every time.
5. **Stay under 500 lines.** Put details in supporting files.
