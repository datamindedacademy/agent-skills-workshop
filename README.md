# Applied Context Engineering — Building Agent Skills

A hands-on workshop where you build Claude Code skills. You'll leave with at least one working skill and a mental model for when to use skills vs MCP vs RAG vs raw prompting.

## Prerequisites

- Log in to [app.conveyordata.com](https://app.conveyordata.com) with your Dataminded account
- Create a **Conveyor IDE** for the `hackathon` project — it comes with Claude Code pre-installed and configured with Bedrock
- Basic git and terminal knowledge
- Skim `cheatsheet.md` before you start

## Exercise

Everyone starts here:

| Skill | Difficulty | You'll learn |
|---|---|---|
| PR Review | Warm-up | `!command` injection, structured output |

## Ideas

Pick one or more after completing the exercise:

| Skill | Difficulty | You'll learn |
|---|---|---|
| Jonnify | Medium | API integration, supporting files, `$ARGUMENTS` |
| Benchmark | Medium | Measuring skill value with token counts |
| Sandi | Medium | CLI wrapping, supporting files, `allowed-tools` |
| Anti-Skill (Swill) | Medium | Skill design by breaking things |

## How to start

1. Do the warm-up first:
   ```bash
   cd exercises/pr-review
   ```
2. Pick an idea:
   ```bash
   cd exercises/<idea-name>
   ```
3. Each exercise dir has a skeleton and TODOs — follow them one at a time.

Solutions live in the `solutions/` directory. Don't peek until you've tried.

## Testing your skill locally

Skills are picked up from the `.claude/` directory relative to where you run Claude. To test an exercise skill:

```bash
cd exercises/<skill-name>
claude
# then invoke: /skill-name <args>
```

Claude will find the `.claude/skills/` directory inside that folder.

## Reference

- `cheatsheet.md` — skill syntax quick reference
- `CLAUDE.md` — project context (itself a context engineering example)
