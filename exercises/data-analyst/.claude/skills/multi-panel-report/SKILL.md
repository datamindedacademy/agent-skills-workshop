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

A real report isn't three canned queries. Each section is its own small
investigation: you poke at the numbers, notice something, chase it down, and
only then write the paragraph. This skill gives each section its own subagent to
do exactly that, in parallel, and assembles their findings into one report.

## Why fan out here

The point isn't speed. Three sections on this little warehouse run fast either
way. The point is **focus**.

A real investigation is messy: you run a query, it raises a question, you run
three more, most of them dead ends. Do all three sections in one conversation
and that mess piles up, and the threads tangle. Give each section its own
subagent and each keeps its own exploration to itself, handing back only a clean
paragraph. That's why this scales to a 30-section report, and why a single
question (just use `/talk-to-your-data`) shouldn't fan out at all.

## The sections

TODO 3: Define three sections, each as a *question to answer*, not a query to
run. A good split for this warehouse: revenue (is it healthy, does a few
customers/orders dominate?), customers (who are they, who matters most?), order
health (are orders clean, what makes the numbers lie?).

## Steps

1. TODO 4: Fan out one subagent per section, in parallel (a single message with
   multiple Task calls, not one after another).
   <!--
   Write the subagent prompt as a template with the section name and question
   filled in. Each subagent should:
     - query ../../data/warehouse.duckdb READ-ONLY via the duckdb CLI
     - INVESTIGATE, not run one query: start broad, follow leads, confirm
     - respect the same data-quirk rules as talk-to-your-data
     - return ONLY the finished panel (heading, small table, 2-3 insights,
       caveat) and keep its exploration to itself
   -->

2. TODO 5: Assemble the finished panels (don't re-run their queries) and write a
   3-bullet executive summary that synthesizes ACROSS sections: the story no
   single subagent could see.

## Output format

<!--
TODO 6: Specify the report layout: title, executive summary bullets, the three
sections in order, and one merged data-caveats line at the bottom.
-->
