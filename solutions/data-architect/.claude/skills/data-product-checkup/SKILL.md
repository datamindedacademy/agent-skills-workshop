---
name: data-product-checkup
description: >
  Score the health and governance of a data product or dbt warehouse. Use when
  asked to check data product health, governance, documentation coverage, test
  coverage, or the quality of the dbt models: runs the checkup framework and
  reports a graded scorecard.
allowed-tools: Bash, Read
---

# Data Product Checkup

Score the **health of a data product**: our dbt warehouse: with the
[`checkup`](https://pypi.org/project/checkup/) governance framework, and report
a clear scorecard.

## How it works

`checkup` reads the dbt project and computes *governance* metrics: how many models
are documented, column test coverage, number of tests, etc. Metrics are
configured in `checkup.yaml` (in the exercise directory).

## Steps

1. From the exercise directory, run checkup:
   ```bash
   checkup run -c checkup.yaml
   ```
   It parses the dbt project in `../../data`: no manifest required.
   (If `checkup` is not on PATH: e.g. outside the workshop IDE: use
   `uv run --with checkup --with checkup-dbt --with dbt-duckdb checkup run -c checkup.yaml`.)

2. Read the metric values from checkup's table output (Name → Value).

3. Turn the numbers into the scorecard below. Derive the grade from coverage:
   documentation completeness (`dbt_models_with_description / dbt_models`) and
   `dbt_column_test_coverage`. A ≥90%, B ≥75%, C ≥60%, D ≥40%, F below.

## Output format

```
## 🩺 Data Product Health: workshop-warehouse: Grade: <A–F>
<one-sentence verdict>

| Metric | Value | Status |
|---|---|---|
| Models documented | x/5 | ✅/⚠️/❌ |
| Column test coverage | NN% | ✅/⚠️/❌ |
| Generic tests | N | … |
| Columns without description | N | … |

### Top gaps (most impactful first)
1. …
2. …
```

Status thresholds: ✅ ≥90%, ⚠️ 60–89%, ❌ <60% (or any undocumented models).
