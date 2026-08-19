# Stage 1: Build `talk-to-your-data` (45 min)

Ask the warehouse questions in plain language; the skill writes the SQL, runs
it read-only, and explains the result.

1. Get to know the data first. Explore it directly and form your own opinion of
   what's trustworthy and what isn't:
   ```bash
   duckdb -readonly ../../../data/warehouse.duckdb -c "SHOW ALL TABLES;"
   duckdb -readonly ../../../data/warehouse.duckdb -c "SELECT * FROM fct_orders LIMIT 20;"
   ```
   Rather not use the CLI? Run the same queries in the DuckDB extension's SQL
   editor (the warehouse is pre-attached; see the track README), or start
   `claude` and ask it: *"show me all tables in
   `../../../data/warehouse.duckdb` and the first 20 rows of fct_orders"*.

   Whatever quirks you find are *the point*: your skill will encode what you
   learn so the agent stops tripping over them.
2. Open `.claude/skills/talk-to-your-data/SKILL.md` and work the TODOs in order.
3. Test it:
   ```bash
   claude
   # then ask: "Which country generates the most revenue?"
   # or invoke directly: /talk-to-your-data
   ```

> **Tip:** editing the skill while a `claude` session is open? Run
> `/reload-skills` in that session to pick up your changes.

## Done when

Run the checker from this folder:

```bash
bash tests/test-talk-to-your-data.sh
```

It verifies the structure (no TODOs, right tools, dynamic schema, quirk rules)
and then hands you the behavioural test. You're done when all three hold:

- [ ] Asking a data question **without naming the skill** triggers it — that's
      your `description` doing its job.
- [ ] Every answer shows the SQL it ran and a small result table.
- [ ] A **caveat** calls out any quirk that affects the number (status casing,
      the amount outlier, country variants).

## Stretch: play with the model

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
