---
name: multi-panel-report
description: >
  Build a multi-section business report on the workshop warehouse. Use when
  asked for a full report, dashboard summary, or business overview of the data.
  Fans out one subagent per report section in parallel (revenue, customers,
  order health), then assembles one report.
allowed-tools: Bash, Task
---

# Multi-panel report (subagents)

Each section of a real report is its own small investigation: you poke at the
numbers, notice something, chase it down, and only then write the paragraph.
This skill gives each section its own subagent to do that digging in parallel,
then assembles their findings into one report.

## Why fan out here

Fanning out here buys you **focus**. Three sections on this little warehouse run
fast either way, so the speed barely matters.

A real investigation is messy: you run a query, it raises a question, you run
three more, most of them dead ends. Do all three sections in one conversation
and that mess piles up. The revenue dead-ends are still sitting in the window
while you try to reason about customer churn, and the thread gets muddy. Give
each section its own subagent and each one keeps its own exploration to itself.
They hand back a clean paragraph; you never see the dead ends. That's the whole
trick, and it's exactly how it scales to a 30-section monthly report.

If someone asks a single question, none of this applies. Just use
`/talk-to-your-data`.

## The sections

Frame each as a question to *answer*:

1. **Revenue**: how much are we making, and is it healthy? (Trend over time,
   and whether a few orders or customers dominate the total.)
2. **Customers**: who are they and who matters most? (Counts, where they are,
   who spends the most.)
3. **Order health**: are orders going through cleanly? (Completion vs
   refund/cancel rates, and anything in the data that makes the numbers lie.)

## Steps

1. Fan out one subagent per section, in parallel: a single message with one
   `Task` call each (not one after another). Prompt template:

   > Investigate the **<SECTION>** section of a business report on the warehouse
   > at `../../data/warehouse.duckdb`. Query it READ-ONLY with
   > `duckdb -readonly ../../data/warehouse.duckdb -c "<SQL>"`, against the marts
   > (`dim_customers`, `fct_orders`, `customer_order_summary`). Treat it as an
   > investigation: start broad, follow what looks interesting, and confirm
   > before you conclude. Mind the data quirks (mixed-case `status`,
   > unstandardized `country`, the `999999` amount, the `2099` date) and flag
   > them where they change a number. Question to answer: <SECTION QUESTION>.
   > Return ONLY the finished panel: a `### <SECTION>` heading, a small table of
   > the numbers that matter, 2-3 insight bullets, and a one-line caveat. Keep
   > your exploration to yourself.

2. Collect the three finished panels. Don't re-run their queries, and don't let
   one panel's findings rewrite another's.

3. Write a 3-bullet **executive summary** on top: the cross-section story no
   single subagent could see (for example, revenue leans on a handful of
   customers while one order in ten is refunded or cancelled).

## Output format

```
# 📊 Warehouse Business Report (<date>)

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
