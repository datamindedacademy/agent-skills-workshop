---
name: sorting-hat
description: >
  Help a workshop participant choose their track: Data Engineer, Data Analyst,
  or Data Steward. Explicitly invoked only, via /sorting-hat: never auto-run.
disable-model-invocation: true
allowed-tools: AskUserQuestion
model: eu.anthropic.claude-sonnet-4-6
---

# The Sorting Hat

Ask three questions, then recommend a track. Option order is always
**Engineer, Analyst, Steward**, so answers map by position.

| Track | Directory | You'll build |
|---|---|---|
| ⚙️ Data Engineer | `data-engineer` | Operate the scheduled dbt pipeline on Airflow; triage failures. |
| 📊 Data Analyst | `data-analyst` | Query your data in plain language; assemble a multi-panel report. |
| 🛡️ Data Steward | `data-steward` | Score a data product's governance; remediate missing docs and tests. |

## Step 1: Ask

One `AskUserQuestion` call, all three questions, wording verbatim.

**Q1 — `Your work`** — "Which best describes what you spend most of your day doing?"
- **Building pipelines** — Moving and transforming data, scheduling jobs, keeping them healthy.
- **Answering questions** — Querying datasets and turning results into insight and reports.
- **Curating quality & docs** — Making sure datasets are documented, tested, and trustworthy.

**Q2 — `Home turf`** — "Where do you feel most at home?"
- **Terminal & orchestrator** — Airflow, the dbt CLI, reading job logs.
- **SQL editor or notebook** — Writing queries, exploring data interactively.
- **Catalog & schemas** — A data catalog, schema and test definitions, column docs.

**Q3 — `Pet peeve`** — "What frustrates you most in your data work?"
- **Silent breakage** — Data lands late or a job fails, and nobody notices until it's downstream.
- **Slow to insight** — Too much wrangling before you can get a straight answer from the data.
- **Nobody trusts it** — Undocumented columns, disagreeing definitions, nothing guarding the data.

## Step 2: Pick

Count votes (option 1→Engineer, 2→Analyst, 3→Steward). Majority wins. On a
three-way tie, let **Q1** decide and name the runner-up.

## Output

````
## 🎩 The Sorting Hat says: <Track>

<one sentence on why, from their answers and what they'll build>

First read your track's README — it explains the problem, the dataset, and the
two stages:

    exercises/<data-engineer|data-analyst|data-steward>/README.md

Then start stage 1:

```bash
cd exercises/<data-engineer|data-analyst|data-steward>/1-build
claude
```
````

If it was close, add one line naming the runner-up.
