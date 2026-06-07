---
name: portfolio-health
# TODO 1: Write the description. It should trigger when someone asks to assess
# the health of ALL data products / the whole portfolio / a governance scorecard
# ACROSS products (not just one).
description: TODO
# TODO 2: This skill reads files, runs a CLI, AND dispatches subagents. Which
# tools does it need? (hint: one of them lets you launch subagents.)
allowed-tools: TODO
---

# Portfolio Health (subagents)

Assess **every data product in the warehouse in parallel** and synthesize one
governance scorecard.

Our warehouse has three data product (mart) models in `../../data/models/marts/`:
`dim_customers`, `fct_orders`, `customer_order_summary`.

## When to fan out: read this first

- Checking **one** product is a single quick pass → just use `/data-product-checkup`.
- Checking **many** products is independent, parallel, context-heavy work → this
  is exactly when subagents pay off.

You're about to fan out one subagent per product. If there were only one product,
you would **not** use subagents: the overhead (latency, tokens, coordination)
wouldn't be worth it. *That* is the judgment this skill teaches.

## Steps

1. TODO 3: List the data products to assess (the mart models in
   `../../data/models/marts/`).

2. TODO 4: Dispatch **one subagent per product, in parallel** (a single message
   with multiple Task calls: not one after another). Each subagent should
   inspect its product and return a per-product verdict.
   <!--
   Write the subagent prompt as a template with the product name filled in.
   Each subagent should look at: the model's .sql, its description and column
   docs / tests (run checkup or read ../../data/models/marts), and return:
     grade (A–F), documented? tested? top gaps.
   -->

3. TODO 5: Synthesize the per-product verdicts into one **portfolio scorecard**,
   ranked by risk (worst data product first).

## Output format

<!--
TODO 6: Specify the portfolio scorecard: a table of product | grade |
documented | tested | top gap, plus an overall portfolio grade and the single
most urgent action.
-->
