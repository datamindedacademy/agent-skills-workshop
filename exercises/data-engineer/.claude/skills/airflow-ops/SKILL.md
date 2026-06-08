---
name: airflow-ops
# TODO 1: Write the description. This is the line Claude reads to decide WHEN to
# run the skill. It should trigger on questions about DAGs, pipeline runs,
# schedules, or failures ("is the pipeline green", "why did the run fail").
description: TODO
# TODO 2: This skill shells out to the af CLI. Which tool(s) does it need?
allowed-tools: TODO
---

# Airflow Ops (Conveyor)

Operate our managed Airflow on **Conveyor** through the
[`af` CLI](https://github.com/astronomer/agents/tree/main/astro-airflow-mcp):
list, inspect, trigger, and debug DAGs from the conversation.

## Connection recipe

TODO 3: Every `af` command needs two env vars. Write the recipe Claude should
use, prefixed before each command. You ran the exact command in the smoke test
(see this track's README, "Before you start"): the `AIRFLOW_API_URL`, and an
`AIRFLOW_AUTH_TOKEN` from `conveyor auth get`. Spell it out here so the skill is
self-sufficient. Decide: fetch the token fresh per command, or once? (It
expires.) Note for Claude: the env runs Airflow 3 and `af` picks the API version
itself, so don't hardcode `/api/vN`; a 401/403 means the session is stale and
the user should run `conveyor auth login`.

## Current DAGs (live)

<!--
TODO 4: Inject the live DAG list as dynamic context, so Claude sees the CURRENT
state the moment the skill runs. A line starting with !`command` runs at
invocation time and injects its output here. This is the SKILL.md version of the
`!` bang command you ran in the smoke test: use your connection recipe above with
`af dags list`, piped through `head -25`.
-->

## Command map (given)

| Intent | Command |
|---|---|
| Overall health | `af health` |
| List DAGs | `af dags list` |
| Inspect a DAG | `af dags explore <dag_id>` |
| Recent runs | `af runs list --dag-id <dag_id>` |
| Trigger a run | `af runs trigger <dag_id>` |
| Diagnose a failed run | `af runs diagnose <dag_id> <run_id>` |
| Task logs | `af tasks logs <dag_id> <run_id> <task_id>` |

## Rules and output

TODO 5: This is the knowledge the skill carries. Write the rules Claude should
follow:
- Which commands change production state (trigger, pause) and so need the user's
  confirmation before running?
- What should the answer look like? Specify the format: a small table
  (DAG | state | last run | result), a one-sentence verdict ("all green" / "dbt
  build failing since 14:02"), and a suggested next step.
