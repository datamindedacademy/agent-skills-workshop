---
name: airflow-ops
description: >
  Operate the workshop's Conveyor Airflow environment. Use when asked about
  DAGs, pipeline runs, schedules, or task failures — "is the pipeline green",
  "trigger the dbt build", "why did the run fail", "show recent runs" — drives
  the Airflow REST API through the af CLI with Conveyor authentication.
allowed-tools: Bash
---

# Airflow Ops (Conveyor)

Operate our managed Airflow on **Conveyor** through the
[`af` CLI](https://github.com/astronomer/agents/tree/main/astro-airflow-mcp) —
list, inspect, trigger, and debug DAGs from the conversation.

## Current DAGs (live)

!`AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" af dags list 2>&1 | head -25`

## Connection rules

1. Every `af` command needs these two variables — prefix each command (the
   token is short-lived, so fetch it fresh rather than caching it):
   ```bash
   AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" \
   AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" \
   af <command>
   ```
2. If a command returns `401`/`403`, the Conveyor session is stale — ask the
   user to run `conveyor auth login`, then retry.
3. The environment runs **Airflow 3** — `af` detects the version itself, don't
   hardcode `/api/v1` or `/api/v2` into the URL.

## Command map

| Intent | Command |
|---|---|
| Overall health | `af health` |
| What pipelines exist | `af dags list` |
| Inspect one DAG (tasks, source) | `af dags explore <dag_id>` |
| Recent runs of a DAG | `af runs list --dag-id <dag_id>` |
| Trigger a run | `af dags trigger <dag_id>` |
| Trigger and wait for the result | `af runs trigger-wait <dag_id>` |
| Diagnose a failed run | `af runs diagnose <dag_id> <run_id>` |
| Task logs | `af tasks logs <dag_id> <run_id> <task_id>` |
| Pause / unpause | `af dags pause|unpause <dag_id>` |

**Triggering or pausing changes production state — confirm with the user
before doing it** unless they explicitly asked for it.

## Output format

```
## ✈️ Airflow — <what was asked>

| DAG | State | Last run | Result |
|---|---|---|---|
| … | active/paused | <ts> | ✅/❌/🏃 |

**Verdict:** <one sentence — e.g. "all green", "dbt build failing since 14:02">
**Next step:** <suggested action, e.g. "diagnose run X" — or "none">
```

For a single run or failure, replace the table with: run id, state, failed
task(s), and the 3–5 most relevant log lines (not full dumps).
