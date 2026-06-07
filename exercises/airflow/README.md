# Track: Data Engineer: Airflow Ops

You'll build a skill that **operates a production Airflow** (Conveyor's managed
Airflow) from the conversation, then: after the break: a second skill that
fans out **subagents** to triage every failing DAG in parallel.

> **The narrative:** the warehouse the other tracks query (`../../data/
> warehouse.duckdb`) is built by a dbt project. In production that same build
> runs as a **scheduled Airflow DAG** on Conveyor (see `demo/`). You operate it.

## Before you start

1. In the **IDE terminal**, authenticate the Conveyor CLI (opens a browser):
   ```bash
   conveyor auth login
   ```
2. Now meet **bang commands**: in the Claude Code prompt, anything you type
   after `!` runs as a shell command *inside the conversation*: the output
   lands in Claude's context. Start `claude` and fetch the Airflow auth token
   that the `af` CLI needs:
   ```
   ! conveyor auth get --quiet | jq -r '.access_token'
   ```
   That token (plus the API URL) is everything `af` needs, and you just
   handed it to the agent without copy-pasting anything.
3. Still in Claude, smoke-test the connection: this is the recipe your skill
   will encode:
   ```
   ! AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" af health
   ```
   (`af` is the [Astronomer Airflow CLI](https://github.com/astronomer/agents/tree/main/astro-airflow-mcp),
   pre-installed in the workshop IDE.)
4. A skill is just a folder under `.claude/skills/`: this track ships two
   skeletons there already.

> **Why this matters:** you just did *manually* what your skill will do
> *automatically*. The `!` prefix is you injecting live context; a skill can
> do the same two ways: running commands via the `Bash` tool, and the
> `` !`command` `` syntax in `SKILL.md`, which injects a command's output as
> context every time the skill is invoked.

## Stage 1: Build (0:30–1:30): `airflow-ops`

Ask about your pipelines in plain language; the skill drives the Airflow API
via `af`: list, inspect, trigger, diagnose.

1. Poke at the environment first with bang commands: `! af dags list`,
   `! af runs list --dag-id …` (with the env vars from the smoke test).
2. Open `.claude/skills/airflow-ops/SKILL.md` and work through the TODOs -
   write the `description`, set `allowed-tools`, inject the live DAG list as
   **dynamic context** (`` !`command` ``: the SKILL.md flavor of the bang
   command you just used), encode the auth recipe (short-lived tokens!), map
   intents to `af` commands, and add a guardrail for state-changing commands.
3. Test it:
   ```bash
   claude
   # then ask: "is the pipeline green?"
   # or invoke directly: /airflow-ops
   ```

You'll know it works when "is the pipeline green?" comes back as a status table
with a verdict, and "trigger the dbt build" asks for confirmation first.

### Stretch: play with the model

A skill can pick its **own model** in the frontmatter: the override lasts
while the skill is active; your session model comes back on the next prompt.

```yaml
---
name: airflow-ops
description: …
model: eu.anthropic.claude-haiku-4-5-20251001-v1:0   # ← try the small model
---
```

Ask "is the pipeline green?" with each and compare:

| `model:` | What to watch |
|---|---|
| *(no field)* | Inherits the session model: Opus 4.8 here |
| `eu.anthropic.claude-sonnet-4-6` | Usually identical ops report, noticeably faster |
| `eu.anthropic.claude-haiku-4-5-20251001-v1:0` | Fastest: does it still pick the right `af` command and respect the confirmation guardrail? |

Run `/model` to see what's active. The interesting question isn't "which is
best" but **what's the smallest model your skill still works on**: that's the
one it should declare. (There's also an `effort:` field to dial reasoning up
or down on a given model.)

## Stage 2: Add subagents (2:00–3:00): `failure-triage`

When several DAGs fail at once, each diagnosis is independent, log-heavy work -
exactly when subagents earn their keep. (The facilitator will break a few DAGs
for you. You're welcome.)

1. Open `.claude/skills/failure-triage/SKILL.md`.
2. Work through the TODOs: find the failing DAGs, **dispatch one subagent per
   DAG in parallel** (each reads its own logs, returns a compact verdict),
   then synthesize one incident summary ranked by severity.
3. Test it:
   ```bash
   # then: /failure-triage   (or ask: "what's broken?")
   ```

> **The lesson: *when* to fan out.** One failed run = one quick pass (use
> Stage 1 inline, no subagents). Many failing DAGs = fan out, then synthesize.
> The logs are the reason: each subagent absorbs its own log noise and returns
> only a verdict.

## The production demo: `demo/`

How does the dbt build actually get scheduled? The repo root is itself a
Conveyor project: `dags/workshop_dbt.py` shows the Conveyor idiom -
`ConveyorDbtTaskFactory` reads the dbt manifest and generates **one Airflow
task per dbt model**. The facilitator deployed it with `conveyor build &&
conveyor deploy --env workshop`: same dbt project as `../../data`, now with a
schedule and a container. That's the gap between "runs on my laptop" and "runs
in production". (Facilitator details: `demo/README.md`.)

## Stuck?

Peek at `solutions/airflow/`, but try the TODOs first.

## Requirements

The workshop IDE pre-installs `af` (via `uv tool install astro-airflow-mcp`),
`jq`, and the `conveyor` CLI. Running locally instead? Install those three and
authenticate with `conveyor auth login`.
