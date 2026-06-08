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

## Current DAGs (live)

<!--
TODO 3: Inject the live DAG list as dynamic context, so Claude sees the CURRENT
state the moment the skill runs. A line starting with !`command` runs at
invocation time and its output is injected here (the SKILL.md version of the `!`
bang command you used in the prompt). Use the connection recipe below, with
`af dags list`, piped through `head -25`. Try it as a `!` bang command first; if
it works there, it works here.
-->

## Connection recipe (given)

Every `af` command needs these two env vars. The token is short-lived, so fetch
it fresh each time rather than once:

```bash
AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" \
AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" \
af <command>
```

The env runs Airflow 3 and `af` detects the version itself, so don't hardcode
`/api/vN`. If a command returns 401/403, the Conveyor session is stale: tell the
user to run `conveyor auth login`.

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

TODO 4: This is the knowledge the skill carries. Write the rules Claude should
follow:
- Which commands change production state (trigger, pause) and so need the user's
  confirmation before running?
- What should the answer look like? Specify the format: a small table
  (DAG | state | last run | result), a one-sentence verdict ("all green" / "dbt
  build failing since 14:02"), and a suggested next step.
