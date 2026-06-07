---
name: airflow-ops
# TODO 1: Write the description. This is the single most important line: Claude
# reads it to decide WHEN to run this skill. It should trigger on questions about
# DAGs, pipeline runs, schedules, failures: "is the pipeline green", "trigger
# the dbt build", "why did the run fail". Make it specific.
description: TODO
# TODO 2: This skill shells out to the af CLI. Which tool(s) does it need?
allowed-tools: TODO
---

# Airflow Ops (Conveyor)

Operate our managed Airflow on **Conveyor** through the
[`af` CLI](https://github.com/astronomer/agents/tree/main/astro-airflow-mcp) -
list, inspect, trigger, and debug DAGs from the conversation.

## Current DAGs (live)

<!--
TODO 3: Inject the live DAG list as dynamic context, so Claude sees the CURRENT
state of the environment the moment the skill runs. A line starting with
!`command` runs at invocation time and its output is injected here: it's the
SKILL.md flavor of the `! command` you typed in the prompt earlier: same idea,
but now the skill does it for you on every invocation.

You'll need the full authenticated one-liner (see TODO 4) piped through
`head -25`. Try it as a `!` bang command in Claude first: if it works there,
it works as dynamic context.
-->

## Connection rules

1. TODO 4: Write the connection recipe. Every `af` command needs two env vars:
   - `AIRFLOW_API_URL`: Conveyor exposes Airflow at
     `https://app.conveyordata.com/environments/<env>/airflow` (our env: `workshop`)
   - `AIRFLOW_AUTH_TOKEN`: a short-lived bearer token:
     `conveyor auth get --quiet | jq -r '.access_token'`
   Should Claude export the token once, or fetch it fresh per command? (It
   expires. This kind of operational glue is exactly what skills are for.)

2. TODO 5: What should Claude do when a command returns 401/403?

3. The environment runs **Airflow 3**: `af` detects the version itself, don't
   hardcode `/api/v1` or `/api/v2` into the URL.

## Command map

TODO 6: Give Claude a small intent → command table so it doesn't guess flags.
Run `af --help` (and `af dags --help`, `af runs --help`, `af tasks --help`) and
map at least: health check, list DAGs, inspect a DAG, recent runs, trigger,
diagnose a failed run, task logs.

<!--
TODO 7: Some of those commands CHANGE production state (trigger, pause).
Add a guardrail: which commands need user confirmation first?
-->

## Output format

<!--
TODO 8: Specify the structured output. A good ops answer includes:
  - a small table: DAG | state | last run | result
  - a one-sentence verdict ("all green" / "dbt build failing since 14:02")
  - a suggested next step
Be explicit: the format is what makes the skill's output useful.
-->
