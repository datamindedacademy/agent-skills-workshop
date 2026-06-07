---
name: multi-panel-report
# TODO 1: Write the description. It should trigger when someone asks for a
# FULL report / dashboard summary / business overview of the data (not a single
# question: that's what talk-to-your-data is for).
description: TODO
# TODO 2: This skill runs a CLI AND dispatches subagents. Which tools does it
# need? (hint: one of them lets you launch subagents.)
allowed-tools: TODO
---

# Multi-panel report (subagents)

Produce a **business report with independent panels**, each researched by its
own subagent in parallel, then assembled into one document.

## When to fan out

A single question doesn't need any of this: just use `/talk-to-your-data` and
answer it. Subagents would only add latency and coordination for no gain.

A full report is different. Revenue, customers, order health: each panel has its
own queries and its own reasoning, and none of them depends on the others.
That's the moment fanning out pays off: give every panel its own subagent, let
them work at the same time, and stitch the results together at the end.

## The panels

TODO 3: Define 3 report panels with a clear scope each. A good split for this
warehouse: revenue (trend, with/without outliers), customers (count, countries,
top spenders), order health (status breakdown + data-quality box).

## Steps

1. TODO 4: Dispatch **one subagent per panel, in parallel** (a single message
   with multiple Task calls: not one after another).
   <!--
   Write the subagent prompt as a template with the panel name and scope filled
   in. Each subagent should:
     - query ../../data/warehouse.duckdb READ-ONLY via the duckdb CLI
     - respect the same data-quirk rules as talk-to-your-data
     - return ONLY a markdown panel: heading, small table, 2–3 insights, caveat
   -->

2. TODO 5: Assemble the returned panels into one report (don't re-run their
   queries) and write a 3-bullet executive summary that synthesizes ACROSS
   panels: the one thing no single subagent could write.

## Output format

<!--
TODO 6: Specify the report layout: title, executive summary bullets, the three
panels in order, and one merged data-caveats line at the bottom.
-->
