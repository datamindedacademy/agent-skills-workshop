# Applied Context Engineering — Building Agent Skills

A hands-on workshop where you build Claude Code skills. You'll leave with at least one working skill and a mental model for when to use skills vs MCP vs RAG vs raw prompting.

## Prerequisites

- Devcontainer running, Claude Code working via Bedrock
- Basic git and terminal knowledge
- Skim `cheatsheet.md` before you start

## Exercises

| Branch | Skill | Difficulty | You'll learn |
|---|---|---|---|
| `skill/pr-review` | PR Review | Warm-up | `!command` injection, structured output |
| `skill/jonify` | Jonify | Medium | API integration, supporting files, `$ARGUMENTS` |
| `skill/benchmark` | Benchmark | Medium | Measuring skill value with token counts |
| `skill/terraform-viz` | Terraform Viz | Medium | Supporting files, `allowed-tools`, multi-phase workflows |
| `skill/swill` | Anti-Skill | Medium | Skill design by breaking things |
| `skill/checkup` | Data Quality | TBD | CLI wrapping, iterative loops (awaiting docs) |

## How to start

1. Everyone does the warm-up first:
   ```bash
   git checkout skill/pr-review
   ```
2. Pick a deep track:
   ```bash
   git checkout skill/<track-name>
   ```
3. Each branch has `exercises/` (skeleton + TODOs) and `solutions/` (don't peek).

## Reference

- `cheatsheet.md` — skill syntax quick reference
- `proposal.md` — workshop proposal
- `CLAUDE.md` — project context (itself a context engineering example)
