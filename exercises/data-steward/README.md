# Track: Data Steward

You'll build a skill that measures the **health of a data product** using the
[`checkup`](https://pypi.org/project/checkup/) governance framework, then, after
the break, a second skill that fans out **subagents** to fix the failing checks,
one per check, in parallel.

> **Dataset:** the shared warehouse in `../../data` (built by the engineer's dbt
> project). `checkup` reads its dbt project directly, no manifest needed.

## What's a data product, and what's "health"?

A **data product** is a curated dataset a team owns and others build on: it has
a name, an owner, a documented interface, and tests that guard it. Here the
**warehouse** is the data product, and its mart tables (`dim_customers`,
`fct_orders`, `customer_order_summary`) are the interface consumers query.

**Health** is about governance rather than today's numbers: is every column
documented so consumers know what they're getting, is it tested so breakage gets
caught, does it have a clear owner. `checkup` reads the dbt project and turns
those signals into metrics (documented models, column descriptions, test
coverage), which your skill rolls up into a grade.

## The two stages

Each stage is its own folder with the skill skeleton, its instructions, and a
test that tells you when you're done. **Start `claude` inside the stage
folder** so it picks up that stage's skill.

| | Folder | You build | Time |
|---|---|---|---|
| 1 | [`1-build/`](1-build/) | `data-product-checkup`: a graded governance scorecard | 45 min |
| 2 | [`2-subagents/`](2-subagents/) | `remediate-products`: one subagent per failing check | 60 min |

```bash
cd 1-build && claude       # stage 1; after the break: cd ../2-subagents
```

## Stuck?

Peek at `solutions/data-steward/` (same folder layout), but try the TODOs first.

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
