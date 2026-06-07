# Track: Data Architect: Data Product Checkup

You'll build a skill that measures the **health of a data product** using the
[`checkup`](https://pypi.org/project/checkup/) governance framework, then: after
the break: a second skill that fans out **subagents** to score *every* data
product in parallel.

> **Dataset:** the shared warehouse in `../../data` (built by the engineer's dbt
> project). `checkup` reads its dbt project directly: no manifest needed.

## Before you start: install a skill yourself

The intro skill was pre-installed for you. Now do it by hand once, so you know how:
a skill is just a folder under `.claude/skills/`. This track ships two skeletons
there already: open `.claude/skills/data-product-checkup/SKILL.md`.

## Stage 1: Build (0:30–1:30): `data-product-checkup`

Run `checkup` on the warehouse and report a clear health scorecard.

1. Open `.claude/skills/data-product-checkup/SKILL.md` and `checkup.yaml`.
2. Work through the TODOs: write the `description`, set `allowed-tools`, choose
   the governance metrics, and define the scorecard output.
3. Test it:
   ```bash
   claude
   # then: /data-product-checkup
   ```

You'll know it works when the skill runs checkup and hands you a graded scorecard
(documented models, column test coverage, gaps to fix).

### Stretch: play with the model

A skill can pick its **own model** in the frontmatter: handy when a skill
doesn't need the big model (mechanical CLI wrapping, like this one) or needs
the biggest one (deep analysis). The override lasts while the skill is active;
your session model comes back on the next prompt.

```yaml
---
name: data-product-checkup
description: …
model: eu.anthropic.claude-haiku-4-5-20251001-v1:0   # ← try the small model
---
```

Run `/data-product-checkup` with each and compare:

| `model:` | What to watch |
|---|---|
| *(no field)* | Inherits the session model: Opus 4.8 here |
| `eu.anthropic.claude-sonnet-4-6` | Usually identical scorecard, noticeably faster |
| `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Fastest: is the grading and gap-ranking still sound? |

Run `/model` to see what's active. The interesting question isn't "which is
best" but **what's the smallest model your skill still works on**: that's the
one it should declare. (There's also an `effort:` field to dial reasoning up
or down on a given model.)

## Stage 2: Add subagents (2:00–3:00): `portfolio-health`

A real warehouse has *many* data products. Scoring each one is independent,
parallel work: exactly when subagents earn their keep.

1. Open `.claude/skills/portfolio-health/SKILL.md`.
2. Work through the TODOs: list the products, **dispatch one subagent per
   product in parallel**, then synthesize a portfolio scorecard ranked by risk.
3. Test it:
   ```bash
   # then: /portfolio-health
   ```

> **The lesson: *when* to fan out.** One product = one quick pass (use Stage 1
> inline, no subagents). Many independent products = fan out, then synthesize.
> Subagents cost latency, tokens, and coordination: use them when the work is
> genuinely parallel.

## Stuck?

Peek at `solutions/data-checkup/`, but try the TODOs first.

## Requirements

The workshop IDE pre-installs the `checkup` CLI (with dbt support), so the skills
just invoke:
```bash
checkup run -c checkup.yaml
```
Running locally instead? Use `uv`:
```bash
uv run --with checkup --with checkup-dbt --with dbt-duckdb checkup run -c checkup.yaml
```
