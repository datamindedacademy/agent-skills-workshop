# Track: Data Engineer

Build a skill that **operates a production Airflow instance** (managed by
Conveyor) from the conversation. Then, after the break, a second skill that fans
out **subagents** to triage failures in parallel.

> **Narrative:** the warehouse the other tracks use (`../../data/warehouse.duckdb`)
> is built by a dbt project. In production that build runs as a scheduled
> Airflow DAG on Conveyor (`demo/`). You operate it.

## Before you start

1. Authenticate the Conveyor CLI (opens a browser):
   ```bash
   conveyor auth login
   ```
2. Start `claude`. Text after `!` in the prompt runs as a shell command and its
   output enters the conversation (a "bang command"). Fetch the Airflow token
   the `af` CLI needs:
   ```
   ! conveyor auth get --quiet | jq -r '.access_token'
   ```
   A skill does the same automatically with the `` !`command` `` syntax in
   `SKILL.md`.
3. Smoke-test the connection (the recipe your skill will encode):
   ```
   ! AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" af health
   ```
   `af` is the [Astronomer Airflow CLI](https://github.com/astronomer/agents/tree/main/astro-airflow-mcp),
   pre-installed in the IDE.

## The two stages

Each stage is its own folder with the skill skeleton, its instructions, and a
test that tells you when you're done. **Start `claude` inside the stage
folder** so it picks up that stage's skill.

| | Folder | You build | Time |
|---|---|---|---|
| 1 | [`1-build/`](1-build/) | `airflow-ops`: operate the pipeline in plain language | 45 min |
| 2 | [`2-subagents/`](2-subagents/) | `failure-triage`: one subagent per failing DAG | 60 min |

```bash
cd 1-build && claude       # stage 1; after the break: cd ../2-subagents
```

## The production demo: `demo/`

`demo/` is the scheduled dbt build you operate, deployed to Conveyor Airflow.
It shows the Conveyor idiom: `ConveyorDbtTaskFactory` turns the dbt graph into
**one Airflow task per model**. Read it (or point your agent at the folder) to
see how a laptop dbt project becomes a scheduled production pipeline.

## Stuck?

Peek at `solutions/data-engineer/` (same folder layout), but try the TODOs first.

## Requirements

The IDE pre-installs `af`, `jq`, and `conveyor`. Locally: install those three
and run `conveyor auth login`.
