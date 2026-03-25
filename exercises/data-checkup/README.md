# Track: Data Architect — Data Product Checkup

You'll build a skill that measures the **health of a data product** using the
[`checkup`](https://pypi.org/project/checkup/) governance framework, then — after
the break — a second skill that fans out **subagents** to score *every* data
product in parallel.

> **Dataset:** the shared warehouse in `../../data` (built by the engineer's dbt
> project). `checkup` reads its dbt project directly — no manifest needed.

## Before you start — install a skill yourself

The intro skill was pre-installed for you. Now do it by hand once, so you know how:
a skill is just a folder under `.claude/skills/`. This track ships two skeletons
there already — open `.claude/skills/data-product-checkup/SKILL.md`.

## Stage 1 — Build (0:30–1:30): `data-product-checkup`

Run `checkup` on the warehouse and report a clear health scorecard.

1. Open `.claude/skills/data-product-checkup/SKILL.md` and `checkup.yaml`.
2. Work through the TODOs — write the `description`, set `allowed-tools`, choose
   the governance metrics, and define the scorecard output.
3. Test it:
   ```bash
   claude
   # then: /data-product-checkup
   ```

You'll know it works when the skill runs checkup and hands you a graded scorecard
(documented models, column test coverage, gaps to fix).

## Stage 2 — Add subagents (2:00–3:00): `portfolio-health`

A real warehouse has *many* data products. Scoring each one is independent,
parallel work — exactly when subagents earn their keep.

1. Open `.claude/skills/portfolio-health/SKILL.md`.
2. Work through the TODOs — list the products, **dispatch one subagent per
   product in parallel**, then synthesize a portfolio scorecard ranked by risk.
3. Test it:
   ```bash
   # then: /portfolio-health
   ```

> **The lesson — *when* to fan out.** One product = one quick pass (use Stage 1
> inline, no subagents). Many independent products = fan out, then synthesize.
> Subagents cost latency, tokens, and coordination — use them when the work is
> genuinely parallel.

## Stuck?

Peek at `solutions/data-checkup/` — but try the TODOs first.

## Requirements

`uv` (pinned tooling, no global installs). The skills invoke:
```bash
uv run --with checkup --with checkup-dbt --with dbt-duckdb checkup run -c checkup.yaml
```
