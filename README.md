# Applied Context Engineering — Building Agent Skills

A hands-on workshop where you build Claude Code skills. You'll leave with at least one working skill and a mental model for when to use skills vs MCP vs RAG vs raw prompting.

## Prerequisites

- Log in to [app.conveyordata.com](https://app.conveyordata.com) with your Dataminded account
- Create a **Conveyor IDE** for the `hackathon` project — it comes with Claude Code pre-installed and configured with Bedrock
- Basic git and terminal knowledge
- Skim `cheatsheet.md` before you start

## Exercises

| Branch | Skill | Difficulty | You'll learn |
|---|---|---|---|
| `skill/pr-review` | PR Review | Warm-up | `!command` injection, structured output |
| `skill/jonnify` | Jonnify | Medium | API integration, supporting files, `$ARGUMENTS` |
| `skill/benchmark` | Benchmark | Medium | Measuring skill value with token counts |
| `skill/terraform-viz` | Terraform Viz | Medium | Supporting files, `allowed-tools`, multi-phase workflows |
| `skill/swill` | Anti-Skill | Medium | Skill design by breaking things |
| `skill/sandi` | Sandi | Medium | CLI wrapping, supporting files, `allowed-tools` |

## How to start

1. Everyone does the warm-up first:
   ```bash
   git checkout skill/pr-review
   ```
2. Pick a deep track:
   ```bash
   git checkout skill/<track-name>
   ```
3. Each branch has `exercises/<skill-name>/` with a skeleton and TODOs.
4. Solutions live on `solution/<skill-name>` branches. Don't peek until you've tried.

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
- `proposal.md` — workshop proposal
- `CLAUDE.md` — project context (itself a context engineering example)
