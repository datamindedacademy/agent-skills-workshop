---
name: remediate-products
description: >
  Fix the governance gaps in the warehouse data product: add the missing column
  descriptions and tests its checkup scorecard flagged. Use when asked to
  remediate, document, or add tests to the warehouse, or to make it pass its
  checkup. Fans out a subagent per failing check, then assembles one reviewable
  diff.
allowed-tools: Bash, Read, Edit, Agent
---

# Remediate the data product

`data-product-checkup` gave you a scorecard: which checks the warehouse fails,
and by how much. This skill closes them. Each failing check is its own job, so
hand each to a subagent and assemble one diff to review.

## Why fan out, and over what

We have a single data product here: the warehouse. So we fan out over its
*failing checks*. One subagent fills in the missing column descriptions, another
adds the missing tests. The two jobs are independent (writing docs has nothing to
do with choosing tests), so they run in parallel and you stitch the results
together.

In a real org you'd usually have many data products and run this whole skill
across each one, a subagent per product. The workshop warehouse is a single
product, so we show the same fan-out-then-synthesize pattern over its checks
instead.

One catch worth noticing: both subagents touch the same file,
`../../../data/models/marts/_marts.yml`, sometimes the same column (one adds a
`description`, the other a `data_tests` entry). If they wrote at once they'd
clobber each other. So they don't write. Each *drafts* its changes and hands them
back; you make the single, careful merge at the end. Fan out the thinking,
centralize the change.

## Steps

1. Take the failing checks from the scorecard (run `checkup run -c ../1-build/checkup.yaml` if you
   don't have it). Two here: columns with no `description`, and columns with no
   test.

2. Dispatch one subagent per failing check, in parallel (a single message with
   one `Agent` call each):

   > **Documentation.** Find every column in the marts
   > (`../../../data/models/marts/`) with no `description` in `_marts.yml`. For each,
   > read the model's `.sql` and write a short, accurate description. Return ONLY
   > a list of `{model, column, description}` entries. Do not edit any file.

   > **Tests.** Find every key or foreign-key column in the marts with no test in
   > `_marts.yml`. For each, pick the obvious test (`unique`, `not_null`, or
   > `relationships`). Don't invent tests that would fail on the messy data.
   > Return ONLY a list of `{model, column, test}` entries. Do not edit any file.

3. Merge both lists into `_marts.yml` yourself: add each description and test to
   the right column. Show the diff before writing, then apply it.

4. Verify the way you measured: run `checkup run -c ../1-build/checkup.yaml` again and confirm the
   flagged metrics moved.

## Output format

```
## Remediation changelist

| Check | Fixes |
|---|---|
| Documentation | N columns described |
| Test coverage | N tests added |

<unified diff of _marts.yml>

Re-running checkup: columns without description N → 0, test coverage NN% → MM%.
```

Apply the change only after showing the diff. The review is the real work here:
read the assembled proposal, then ship it.
