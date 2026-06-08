# Track: Data Analyst

You'll build a skill that answers **plain-language questions** about the shared
warehouse with SQL, then, after the break, a second skill that fans out
**subagents** to write a multi-panel business report in parallel.

> **Dataset:** the shared warehouse `../../data/warehouse.duckdb` (built by the
> engineer's dbt project). You query it with the `duckdb` CLI, pre-installed in
> the workshop IDE.

## Before you start

You installed the intro skill yourself (`explore-data`). The skills for this
track are skeletons already under `.claude/skills/`: open
`.claude/skills/talk-to-your-data/SKILL.md`.

## Stage 1: Build (0:30–1:30): `talk-to-your-data`

Ask the warehouse questions in plain language; the skill writes the SQL, runs
it read-only, and explains the result.

1. Get to know the data first. Explore it directly and form your own opinion of
   what's trustworthy and what isn't:
   ```bash
   duckdb -readonly ../../data/warehouse.duckdb -c "SHOW ALL TABLES;"
   duckdb -readonly ../../data/warehouse.duckdb -c "SELECT * FROM fct_orders LIMIT 20;"
   ```
   Whatever quirks you find are *the point*: your skill will encode what you
   learn so the agent stops tripping over them.
2. Open `.claude/skills/talk-to-your-data/SKILL.md` and work through the TODOs:
   write the `description`, set `allowed-tools`, inject the schema as
   **dynamic context** (`` !`command` ``), write the query rules, and define
   the output format.
3. Test it:
   ```bash
   claude
   # then ask: "Which country generates the most revenue?"
   # or invoke directly: /talk-to-your-data
   ```

You'll know it works when the answer comes back with the SQL it ran, a result
table, **and a caveat whenever a data quirk affects the number**.

### Stretch: play with the model

A skill can pick its **own model** in the frontmatter: handy when a skill
doesn't need the big model (cheap classification) or needs the biggest one
(deep analysis). The override lasts while the skill is active; your session
model comes back on the next prompt.

```yaml
---
name: talk-to-your-data
description: …
model: eu.anthropic.claude-haiku-4-5-20251001-v1:0   # ← try the small model
---
```

Try the same question (e.g. *"average order value per country"*) with:

| `model:` | What to watch |
|---|---|
| *(no field)* | Inherits the session model: Opus 4.8 here |
| `eu.anthropic.claude-sonnet-4-6` | Usually as correct, noticeably faster |
| `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Fastest: does it still catch the data quirks? |

Run `/model` to see what's active. The interesting question isn't "which is
best" but **what's the smallest model your skill still works on**: that's the
one it should declare. (There's also an `effort:` field to dial reasoning up
or down on a given model.)

## Stage 2: Add subagents (2:00–3:00): `multi-panel-report`

Each report section is a small investigation: you poke, notice something, chase
it, then write the paragraph. Give each section its own subagent to do that
digging, in parallel, and assemble their findings.

1. Open `.claude/skills/multi-panel-report/SKILL.md`.
2. Work through the TODOs: frame each section as a question, **dispatch one
   subagent per section in parallel** to investigate it, then assemble the
   report with an executive summary across them.
3. Test it:
   ```bash
   # then: /multi-panel-report
   ```

Fanning out here buys focus. A real investigation throws off a lot of dead-end
queries; run three of them in one window and the threads tangle.
Each subagent keeps its own mess to itself and hands back a clean paragraph. A
single question doesn't need any of that, so answer it inline with Stage 1.

## Stuck?

Peek at `solutions/data-analyst/`, but try the TODOs first.

## Requirements

The workshop IDE pre-installs the `duckdb` CLI. Running locally instead?
[Install DuckDB](https://duckdb.org/docs/installation/) (`curl https://install.duckdb.org | sh`
or `brew install duckdb`).
