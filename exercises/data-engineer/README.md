# Track: Data Engineer

Build a skill that **operates a production Airflow** (Conveyor's managed
Airflow) from the conversation. Then, after the break, a second skill that fans
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

## Stage 1: Build `airflow-ops` (0:30–1:30)

Ask about your pipelines in plain language; the skill drives the Airflow API
via `af` (list, inspect, trigger, diagnose).

1. Open `.claude/skills/airflow-ops/SKILL.md` and work the TODOs in order.
2. Use it to answer: **is the pipeline healthy? what was the last run?** Let the
   skill tell you, don't assume.
3. **Diagnose, then fix.** If a run failed, have the skill pull the logs and work
   out what actually caused it. Then fix it at the source in the dbt
   project (`../../data`) and prove it the way Airflow does, locally:
   ```bash
   cd ../../data && uv run dbt build --target prod
   ```
   When that's green, the scheduled run would be too. (No need to redeploy to the
   shared environment during the workshop.)

### Stretch

- **Swap the model.** A skill can declare its own `model:` (override lasts while
  active). Run it on each and find the smallest model it still works on:
  | `model:` | |
  |---|---|
  | *(none)* | session model (Opus 4.8) |
  | `eu.anthropic.claude-sonnet-4-6` | usually identical, faster |
  | `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | fastest, still correct? |
  `/model` shows what's active. (`effort:` dials reasoning up/down too.)
- **Make it manual-only.** This skill can *trigger* and *pause* production DAGs.
  Add `disable-model-invocation: true` so Claude never fires it on its own; you
  invoke it deliberately with `/airflow-ops`. Compare with the in-skill
  confirmation guardrail: two different ways to keep side effects on a leash.

## Stage 2: Add subagents, `failure-triage` (2:00–3:00)

Diagnosing several failures at once is independent, log-heavy work: one
subagent per failure, each reading its own logs, is when subagents earn their
keep.

1. Open `.claude/skills/failure-triage/SKILL.md`.
2. Work through the TODOs: find what's failing, **dispatch one subagent per
   failure in parallel** (each returns a compact verdict), then synthesize one
   incident summary ranked by severity.
3. Run `/failure-triage` (or ask "what's broken?").

One failure: diagnose it inline (Stage 1). Many: fan out, then synthesize. The
win is context: each subagent absorbs its own log noise and returns a verdict,
instead of every log flooding one window.

## The production demo: `demo/`

`demo/` is the scheduled dbt build you operate, deployed to Conveyor Airflow.
It shows the Conveyor idiom: `ConveyorDbtTaskFactory` turns the dbt graph into
**one Airflow task per model**. Read it (or point your agent at the folder) to
see how a laptop dbt project becomes a scheduled production pipeline.

## Stuck?

Peek at `solutions/data-engineer/`, but try the TODOs first.

## Requirements

The IDE pre-installs `af`, `jq`, and `conveyor`. Locally: install those three
and run `conveyor auth login`.
