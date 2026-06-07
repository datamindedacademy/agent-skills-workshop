---
name: portfolio-health
description: >
  Assess the governance health of every data product in the warehouse at once
  and produce a portfolio scorecard. Use when asked to review all data products,
  the whole portfolio, or to compare/ rank data products by health: fans out a
  subagent per product in parallel, then synthesizes.
allowed-tools: Bash, Read, Task
---

# Portfolio Health (subagents)

Assess **every data product in the warehouse in parallel** and synthesize one
governance scorecard.

Our warehouse has three data product (mart) models in `../../data/models/marts/`:
`dim_customers`, `fct_orders`, `customer_order_summary`.

## When to fan out

- **One** product → a single quick pass; use `/data-product-checkup` inline. No subagents.
- **Many** products → independent, parallel, context-heavy work → fan out.

Subagents cost latency, tokens, and coordination. Use them only when the work is
genuinely parallel: which scoring N independent data products is.

## Steps

1. List the data products: the `.sql` files in `../../data/models/marts/`
   (`dim_customers`, `fct_orders`, `customer_order_summary`).

2. Dispatch **one subagent per product, in parallel**: a single message with
   one `Task` call per product (not sequential). Use this prompt template:

   > Assess the governance health of the dbt data product **`<PRODUCT>`**.
   > Read `../../data/models/marts/<PRODUCT>.sql` and its entry in
   > `../../data/models/marts/_marts.yml`. Determine: is the model documented?
   > Are its columns documented and tested? Any obvious quality risks?
   > Return JSON: `{"product": "<PRODUCT>", "grade": "A–F", "documented": bool,
   > "tested": bool, "gaps": ["…"]}`.

3. Collect the per-product verdicts and synthesize the portfolio scorecard,
   ranked worst-first.

## Output format

```
## 🗂️ Portfolio Health: Overall Grade: <A–F>

| Data product | Grade | Documented | Tested | Top gap |
|---|---|---|---|---|
| … | … | ✅/❌ | ✅/❌ | … |

**Most urgent action:** <single highest-impact fix across the portfolio>
```

> Note: with only three products this is fast either way, but the pattern is
> what matters. At 50 products, the parallel fan-out is the difference between
> seconds and minutes.
