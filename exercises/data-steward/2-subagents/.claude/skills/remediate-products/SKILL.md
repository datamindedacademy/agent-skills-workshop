---
name: remediate-products
# TODO 1: Write the description (you did this in Stage 1, keep it quick). It
# should trigger when someone asks to fix / remediate / document / add tests to
# the warehouse, or to make it pass its checkup.
description: TODO
# TODO 2: This skill reads files, dispatches subagents, and edits a file. Which
# tools does it need? (one of them launches subagents.)
allowed-tools: TODO
---

# Remediate the data product

`data-product-checkup` gave you a scorecard: which checks the warehouse fails,
and by how much. This skill closes them. Each failing check is its own job, so
hand each to a subagent and assemble one diff to review.

## Why fan out, and over what

We have a single data product here: the warehouse. So we fan out over its
*failing checks*: one subagent fills in the missing column descriptions, another
adds the missing tests. The two are independent, so they run in parallel and you
stitch the results together.

In a real org you'd usually have many data products and run this whole skill
across each one, a subagent per product. The workshop warehouse is a single
product, so we show the same pattern over its checks instead.

One catch: both subagents touch the same file,
`../../../data/models/marts/_marts.yml`, sometimes the same column. If they wrote at
once they'd clobber each other. So they don't write. Each *drafts* its changes
and hands them back; you make the single, careful merge at the end. Fan out the
thinking, centralize the change.

## Steps

1. Take the failing checks from the scorecard (run `checkup run -c ../1-build/checkup.yaml` if you
   don't have it). Two here: columns with no `description`, and columns with no
   test.

2. TODO 3: Dispatch one subagent per failing check, in parallel. The `Agent` tool
   spawns a subagent; putting one `Agent` call per check in a single message runs
   them at the same time.
   <!--
   Write a prompt for each check. Each subagent should:
     - scan the marts (../../../data/models/marts/) and _marts.yml for its gap:
       one for columns missing a `description`, one for key/FK columns missing a
       test (unique / not_null / relationships; don't invent failing tests)
     - return ONLY a list of targeted edits ({model, column, description} or
       {model, column, test}); it must NOT edit the shared file
   -->

3. TODO 4: Merge both lists into `_marts.yml` yourself. Show the diff first, then
   apply it.

4. TODO 5: Verify the same way you measured: run `checkup run -c ../1-build/checkup.yaml` again
   and check that the flagged metrics moved.

## Output format

<!--
TODO 6: Specify the output: a small table (check | fixes), the diff of
_marts.yml, and the before/after checkup numbers. Apply the change only after
showing the diff.
-->
