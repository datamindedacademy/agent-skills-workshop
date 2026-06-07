---
name: talk-to-your-data
# TODO 1 — Write the description. This is the single most important line: Claude
# reads it to decide WHEN to run this skill. It should trigger on plain-language
# questions about the data — customers, orders, revenue, countries, "how many",
# "top N", trends. Make it specific.
description: TODO
# TODO 2 — This skill shells out to the duckdb CLI. Which tool(s) does it need?
allowed-tools: TODO
---

# Talk to your data

Turn a plain-language question into SQL, run it **read-only** against the
warehouse, and explain the answer like a colleague would.

## Warehouse schema (live)

<!--
TODO 3 — Inject the schema dynamically so Claude always sees the CURRENT tables
and columns (not a stale copy you pasted). Skills support dynamic context:
a line starting with !`command` runs at invocation time and its output is
injected right here. Hint:

  !`duckdb -readonly ../../data/warehouse.duckdb -c "SHOW ALL TABLES;"`

(backtick-wrapped, prefixed with ! — see cheatsheet.md)
-->

## Rules for querying

1. **Database:** `../../data/warehouse.duckdb`. Always run read-only:
   ```bash
   duckdb -readonly ../../data/warehouse.duckdb -c "<SQL>"
   ```
2. TODO 4 — Which tables should Claude query, and which should it avoid?
   (Look at the schema: there are raw, staging, and mart tables. Marts are the
   curated products.)

3. TODO 5 — This warehouse has **known data quirks** (run a few GROUP BY
   queries on `status` and `country`, and look at min/max of `amount` and
   `order_date`). Write rules so Claude handles them — and *tells the user*
   when they affect an answer. This is the heart of the skill: encoding what
   YOU know about your data so the agent stops tripping over it.

## Output format

<!--
TODO 6 — Specify the structured output. A good answer includes:
  - one plain-language sentence with the number(s)
  - the SQL that was run (so the user can check it)
  - a small result table
  - caveats: which data quirks affect this answer
Be explicit — the format is what makes the skill's output trustworthy.
-->
