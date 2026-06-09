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

## Before you start

You installed the intro skill yourself (`explore-data`). The skills for this
track are skeletons already under `.claude/skills/`: open
`.claude/skills/data-product-checkup/SKILL.md`.

## Stage 1: Build (45 min): `data-product-checkup`

Run `checkup` on the warehouse and report a clear health scorecard.

1. Open `.claude/skills/data-product-checkup/SKILL.md` and `checkup.yaml`, and
   work the TODOs in order (the metrics live in `checkup.yaml`, the rest in the
   SKILL).
2. Test it:
   ```bash
   claude
   # then: /data-product-checkup
   ```

You'll know it works when the skill runs checkup and hands you a graded
scorecard you can act on, with the biggest gaps called out first.

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

## Stage 2: Add subagents (60 min): `remediate-products`

Stage 1's scorecard told you which checks the warehouse fails. Now fix them. Each
failing check (missing descriptions, missing tests) is its own job, so hand each
to a subagent that drafts the fixes, and assemble them into a single diff you
review.

1. Open `.claude/skills/remediate-products/SKILL.md` and work the TODOs in order.
2. Test it:
   ```bash
   # then: /remediate-products
   ```

With one data product, we fan out over its failing *checks*. In a real org you'd
more often have many data products and fan out one subagent per product, running
this whole skill across each; here we show the same pattern on what we have.
Either way the wrinkle is the same: the subagents draft in parallel but *don't*
write (they share one schema file), and you make the single careful merge at the
end. Fan out the thinking, centralize the change.

## Stuck?

Peek at `solutions/data-steward/`, but try the TODOs first.

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
