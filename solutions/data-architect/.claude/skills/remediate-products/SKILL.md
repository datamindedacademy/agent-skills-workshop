---
name: remediate-products
description: >
  Fix the governance gaps in the warehouse: add missing column descriptions and
  tests to the dbt data products. Use when asked to remediate, document, or add
  tests to the data products, or to make the warehouse pass its checkup. Fans
  out a subagent per data product to draft the fixes, then assembles one
  reviewable changelist.
allowed-tools: Bash, Read, Edit, Task
---

# Remediate the portfolio

`data-product-checkup` told you *what's* undocumented and untested. This skill
does something about it: each data product gets a subagent that drafts the
missing descriptions and tests, and you end up with one diff to review.

## Why a subagent per product

Documenting a model is a small, self-contained job: read its SQL, look at what
the columns mean, write a sentence and pick a sensible test for each. The three
marts have nothing to do with each other while you do this, so there's no reason
to do them one after another. Give each its own subagent and they draft in
parallel.

There's a catch worth noticing: all three share one file,
`../../data/models/marts/_marts.yml`. If the subagents all edited it at once
they'd clobber each other. So they don't edit anything. Each one *drafts* its
model's YAML and hands it back; you do the single, careful write at the end.
Fan out the thinking, centralize the change.

## Steps

1. The data products are the marts in `../../data/models/marts/`:
   `dim_customers`, `fct_orders`, `customer_order_summary`.

2. Dispatch one subagent per product, in parallel (a single message with one
   `Task` call each). Prompt template:

   > Draft governance fixes for the dbt model **`<PRODUCT>`**. Read
   > `../../data/models/marts/<PRODUCT>.sql` and its current entry in
   > `../../data/models/marts/_marts.yml`. For every column with no
   > `description`, write a short, accurate one from what the SQL does. For key
   > and foreign-key columns with no test, add the obvious one (`unique`,
   > `not_null`, or `relationships`). Don't invent tests that would fail on
   > messy data. Return ONLY the complete updated YAML block for this one model
   > (the `- name: <PRODUCT>` entry), ready to drop into `_marts.yml`.

3. Collect the three blocks and merge them into `_marts.yml`, replacing each
   model's entry. Show the diff before writing, then apply it.

4. Verify your work the same way you measured it: run `/data-product-checkup`
   again and confirm documentation and test coverage went up.

## Output format

```
## Remediation changelist

| Data product | Descriptions added | Tests added |
|---|---|---|
| … | N | … |

<unified diff of _marts.yml>

Re-running checkup: documentation NN% → MM%, column tests X → Y.
```

Apply the change only after showing the diff. The point isn't to rubber-stamp
whatever the agents wrote: it's to review a clean, assembled proposal and ship it.
