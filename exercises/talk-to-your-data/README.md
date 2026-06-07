# Track: Analyst / BI: Talk to your data

You'll build a skill that answers **plain-language questions** about the shared
warehouse with SQL, then: after the break: a second skill that fans out
**subagents** to write a multi-panel business report in parallel.

> **Dataset:** the shared warehouse `../../data/warehouse.duckdb` (built by the
> engineer's dbt project). You query it with the `duckdb` CLI: pre-installed
> in the workshop IDE.

## Before you start: install a skill yourself

The intro skill was pre-installed for you. Now do it by hand once, so you know
how: a skill is just a folder under `.claude/skills/`. This track ships two
skeletons there already: open `.claude/skills/talk-to-your-data/SKILL.md`.

## Stage 1: Build (0:30–1:30): `talk-to-your-data`

Ask the warehouse questions in plain language; the skill writes the SQL, runs
it read-only, and explains the result.

1. Get to know the data first: poke at it directly:
   ```bash
   duckdb -readonly ../../data/warehouse.duckdb -c "SHOW ALL TABLES;"
   duckdb -readonly ../../data/warehouse.duckdb -c "SELECT status, count(*) FROM fct_orders GROUP BY 1;"
   ```
   Notice anything odd? (Look at status casing, country values, max amount,
   max order date.) Those quirks are *the point*: your skill will encode them.
2. Open `.claude/skills/talk-to-your-data/SKILL.md` and work through the TODOs
  : write the `description`, set `allowed-tools`, inject the schema as
   **dynamic context** (`` !`command` ``), write the query rules, and define
   the output format.
3. Test it:
   ```bash
   claude
   # then ask: "Which country generates the most revenue?"
   # or invoke directly: /talk-to-your-data
   ```

You'll know it works when the answer comes back with the SQL it ran, a result
table, **and a caveat about the data quirks** (e.g. the 999999 outlier).

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
| `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Fastest: does it still catch the status-casing trap? |

Run `/model` to see what's active. The interesting question isn't "which is
best" but **what's the smallest model your skill still works on**: that's the
one it should declare. (There's also an `effort:` field to dial reasoning up
or down on a given model.)

## Stage 2: Add subagents (2:00–3:00): `multi-panel-report`

A business report has *independent* sections: revenue, customers, order
health. Each needs its own queries and reasoning: exactly when subagents earn
their keep.

1. Open `.claude/skills/multi-panel-report/SKILL.md`.
2. Work through the TODOs: define the panels, **dispatch one subagent per
   panel in parallel**, then assemble the report with an executive summary.
3. Test it:
   ```bash
   # then: /multi-panel-report
   ```

> **The lesson: *when* to fan out.** One question = one quick pass (use Stage
> 1 inline, no subagents). A report of independent panels = fan out, then
> synthesize. Subagents cost latency, tokens, and coordination: use them when
> the work is genuinely parallel.

## Stuck?

Peek at `solutions/talk-to-your-data/`, but try the TODOs first.

## Requirements

The workshop IDE pre-installs the `duckdb` CLI. Running locally instead?
[Install DuckDB](https://duckdb.org/docs/installation/) (`curl https://install.duckdb.org | sh`
or `brew install duckdb`).
