---
name: data-product-checkup
# TODO 1: Write the description. This is the single most important line: Claude
# reads it to decide WHEN to run this skill. The behavioural test asks a health
# question WITHOUT naming the skill — what words would that question use?
description: TODO
# TODO 2: Which tools does this skill need? List only those.
allowed-tools: TODO
---

# Data Product Checkup

Score the **health of a data product** (our dbt warehouse) with the
[`checkup`](https://pypi.org/project/checkup/) governance framework, and report
a clear scorecard.

## Steps

1. From the exercise directory, run checkup:
   ```bash
   checkup run -c checkup.yaml
   ```
   It parses the dbt project in `../../../data`: no manifest required.
   (If `checkup` is not on PATH: e.g. outside the workshop IDE: use
   `uv run --with checkup --with checkup-dbt --with dbt-duckdb checkup run -c checkup.yaml`.)

2. TODO 3: Write the remaining steps: what does Claude do with checkup's
   output, and how does it decide what's good or bad?

## Output format

<!--
TODO 4: Specify the scorecard. The README lists what it contains — your job
is to spell it out here so precisely that the output looks the same on every
run. Vague specs produce vague output.
-->
