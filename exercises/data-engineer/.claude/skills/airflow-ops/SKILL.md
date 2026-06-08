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
bang command you used in the prompt). Use the authenticated one-liner from
TODO 4, piped through `head -25`. Try it as a `!` bang command first; if it
works there, it works here.
-->

## Connection recipe

TODO 4: Every `af` command needs two env vars. Write the recipe Claude should
use, prefixed before each command:

- `AIRFLOW_API_URL`: `https://app.conveyordata.com/environments/workshop/airflow`
- `AIRFLOW_AUTH_TOKEN`: a short-lived token from
  `conveyor auth get --quiet | jq -r '.access_token'`

The token expires, so fetch it fresh per command rather than once. The env runs
**Airflow 3**; `af` detects the version itself, so don't hardcode `/api/vN`.
(If a command returns 401/403, the Conveyor session is stale: tell the user to
run `conveyor auth login`.)

## Command map

TODO 5: Give Claude a small intent → command table so it doesn't guess flags.
Run `af --help` (and `af dags|runs|tasks --help`) and map at least: health
check, list DAGs, inspect a DAG, recent runs, trigger a run, diagnose a failed
run, task logs. Note which commands change production state (trigger, pause) so
Claude confirms with the user before running them.

## Output format

<!--
TODO 6: Specify the structured output. A good ops answer has:
  - a small table: DAG | state | last run | result
  - a one-sentence verdict ("all green" / "dbt build failing since 14:02")
  - a suggested next step
-->
