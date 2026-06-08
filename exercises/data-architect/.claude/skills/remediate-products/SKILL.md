---
name: remediate-products
# TODO 1: Write the description. It should trigger when someone asks to fix /
# remediate / document / add tests to the data products, or to make the
# warehouse pass its checkup. (Stage 1 measured the gaps; this skill closes them.)
description: TODO
# TODO 2: This skill reads files, dispatches subagents, and edits a file. Which
# tools does it need? (one of them launches subagents.)
allowed-tools: TODO
---

# Remediate the portfolio

`data-product-checkup` told you *what's* undocumented and untested. This skill
does something about it: each data product gets a subagent that drafts the
missing descriptions and tests, and you end up with one diff to review.

## Why a subagent per product

Documenting a model is a small, self-contained job: read its SQL, work out what
the columns mean, write a sentence and pick a sensible test for each. The marts
have nothing to do with each other while you do this, so there's no reason to do
them one at a time. Give each its own subagent and they draft in parallel.

One catch worth noticing: all the marts share a single file,
`../../data/models/marts/_marts.yml`. If the subagents all edited it at once
they'd clobber each other. So they shouldn't. Have each one *draft* its YAML and
hand it back; you make the single, careful write at the end. Fan out the
thinking, centralize the change.

## Steps

1. List the data products: the marts in `../../data/models/marts/`.

2. TODO 3: Dispatch one subagent per product, in parallel. The `Agent` tool is
   what spawns a subagent; putting one `Agent` call per product in a single
   message runs them at the same time.
   <!--
   Write the subagent prompt as a template with the product name filled in.
   Each subagent should:
     - read the model's .sql and its current entry in _marts.yml
     - write a short, accurate description for every undocumented column
     - add the obvious test for key / foreign-key columns (unique, not_null,
       relationships) without inventing tests that would fail on messy data
     - return ONLY the updated YAML block for its one model (it must NOT edit
       the shared file)
   -->

3. TODO 4: Merge the returned blocks into `_marts.yml`. Show the diff first,
   then apply it.

4. TODO 5: Verify the same way you measured: run `/data-product-checkup` again
   and check that documentation and test coverage went up.

## Output format

<!--
TODO 6: Specify the output: a small table (product | descriptions added | tests
added), the diff of _marts.yml, and the before/after checkup numbers. Apply the
change only after showing the diff.
-->
