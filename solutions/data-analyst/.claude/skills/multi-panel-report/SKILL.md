---
name: multi-panel-report
description: >
  Build a multi-section business report on the workshop warehouse. Use when
  asked for a full report, dashboard summary, or business overview of the data
 : fans out one subagent per report panel in parallel (revenue, customers,
  order status & data quality), then assembles one report.
allowed-tools: Bash, Task
---

# Multi-panel report (subagents)

Produce a **business report with independent panels**, each researched by its
own subagent in parallel, then assembled into one document.

## When to fan out

- **One** question → just use `/talk-to-your-data` inline. No subagents.
- A **report of independent sections** → each panel needs its own queries and
  reasoning, none depends on another → fan out, then assemble.

Subagents cost latency, tokens, and coordination. A report is worth it because
each panel is genuinely independent, parallel, context-heavy work.

## The panels

1. **Revenue**: total & monthly revenue trend from `fct_orders` (completed
   orders), with and without the `999999` outlier.
2. **Customers**: customer count, top countries (note the `USA`/`US`/`us`
   variants), top customers by total spend from `customer_order_summary`.
3. **Order health**: order counts by normalized `lower(status)`, refund/cancel
   rate, plus a data-quality box: casing duplicates, future `2099` date,
   outlier amount, NULL country.

## Steps

1. Dispatch **one subagent per panel, in parallel**: a single message with one
   `Task` call per panel (not sequential). Use this prompt template:

   > Write the **<PANEL>** panel of a business report on the warehouse at
   > `../../data/warehouse.duckdb`. Query it READ-ONLY with
   > `duckdb -readonly ../../data/warehouse.duckdb -c "<SQL>"`.
   > Query the marts (`dim_customers`, `fct_orders`, `customer_order_summary`),
   > compare status with `lower(status)`, and call out data quirks (outlier
   > amounts, future dates, country variants) where they affect your numbers.
   > Scope: <PANEL SCOPE FROM THE LIST ABOVE>.
   > Return ONLY markdown: `### <PANEL>` heading, a small table of key numbers,
   > 2–3 bullet insights, and a one-line caveat.

2. Collect the three panels and assemble the report: do not re-run their
   queries, and do not let one panel's findings rewrite another's.

3. Write a 3-bullet **executive summary** at the top, synthesizing across
   panels (e.g. "revenue concentrated in few customers; ~10% of orders
   refunded/cancelled; data quality issues inflate totals").

## Output format

```
# 📊 Warehouse Business Report: <date>

**Executive summary**
- …
- …
- …

### Revenue
<panel as returned>

### Customers
<panel as returned>

### Order health
<panel as returned>

---
*Data caveats: <one merged line of the panels' caveats>*
```

> With three panels the fan-out is modest, but the pattern scales: a 12-panel
> monthly report runs in the time of the slowest panel, not the sum of all.
