---
name: data-product-checkup
# TODO 1: Write the description. This is the single most important line: Claude
# reads it to decide WHEN to run this skill. It should trigger when someone asks
# to check the health / governance / documentation / test coverage of a data
# product or the dbt warehouse. Make it specific.
description: TODO
# TODO 2: This skill runs a CLI command and reads its output. Which tools does
# it need? (hint: it shells out, and may read project files.)
allowed-tools: TODO
---

# Data Product Checkup

Score the **health of a data product** (our dbt warehouse) with the
[`checkup`](https://pypi.org/project/checkup/) governance framework, and report
a clear scorecard.

## How it works

`checkup` reads the dbt project and computes *governance* metrics: how many models
are documented, column test coverage, number of tests, naming conventions, etc.
The metrics are configured in `checkup.yaml` (in the exercise directory).

## Steps

1. From the exercise directory, run checkup:
   ```bash
   checkup run -c checkup.yaml
   ```
   It parses the dbt project in `../../../data`: no manifest required.
   (If `checkup` is not on PATH: e.g. outside the workshop IDE: use
   `uv run --with checkup --with checkup-dbt --with dbt-duckdb checkup run -c checkup.yaml`.)

2. TODO 3: Read the metric values from checkup's table output.

3. TODO 4: Turn the raw numbers into a **scorecard** for a human (see below).

## Output format

<!--
TODO 5: Specify the structured output. A good scorecard includes:
  - one summary line with an overall health GRADE (A–F) and a sentence
  - a table: metric | value | status (✅ good / ⚠️ warn / ❌ bad)
  - a prioritized list of the top gaps to fix, most impactful first
Be explicit: the format is what makes the skill's output useful.
-->
