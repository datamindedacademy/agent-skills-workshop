---
name: failure-triage
description: >
  Triage all failing pipelines in the Conveyor Airflow environment at once and
  produce a single incident summary. Use when asked "what's broken", "triage
  the failures", or for an incident overview across DAGs — fans out one
  subagent per failed DAG to diagnose root causes in parallel, then synthesizes.
allowed-tools: Bash, Task
---

# Failure Triage (subagents)

Diagnose **every failing DAG in parallel** and synthesize one incident summary.

## When to fan out

- **One** failed run → just diagnose it inline with `/airflow-ops`. No subagents.
- **Several** DAGs failing → each diagnosis is independent, log-heavy work
  (logs would flood one context) → fan out, then synthesize.

Subagents cost latency, tokens, and coordination. Use them only when the work
is genuinely parallel — which diagnosing N independent failures is.

## Steps

1. Find what's failing (fresh token per command, see `/airflow-ops`):
   ```bash
   AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow" \
   AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')" \
   af dags list
   ```
   Then for each active DAG check its latest runs
   (`af runs list --dag-id <dag_id>`) and keep the DAGs whose **latest run
   failed**. If nothing failed, report all-green and stop — do not fan out.

2. Dispatch **one subagent per failed DAG, in parallel** — a single message
   with one `Task` call per DAG (not sequential). Use this prompt template:

   > Diagnose the failed Airflow DAG **`<DAG_ID>`** (latest failed run:
   > `<RUN_ID>`). Run af with:
   > `AIRFLOW_API_URL="https://app.conveyordata.com/environments/workshop/airflow"
   > AIRFLOW_AUTH_TOKEN="$(conveyor auth get --quiet | jq -r '.access_token')"`.
   > Use `af runs diagnose <DAG_ID> <RUN_ID>`, then pull logs for the failed
   > task(s) with `af tasks logs`. Identify the ROOT CAUSE, not the symptom.
   > Return JSON: `{"dag": "<DAG_ID>", "run": "<RUN_ID>", "failed_task": "…",
   > "root_cause": "…", "evidence": "<key log line>",
   > "suggested_fix": "…", "severity": "high|medium|low"}`.

3. Collect the verdicts and synthesize the incident summary, ranked by
   severity. Group failures that share a root cause (e.g. one upstream outage
   breaking three DAGs) — that cross-DAG link is the thing no single subagent
   can see.

## Output format

```
## 🚨 Incident Summary — <N> failing DAG(s)

| DAG | Failed task | Root cause | Severity | Suggested fix |
|---|---|---|---|---|
| … | … | … | 🔴/🟠/🟡 | … |

**Common cause:** <shared root cause across DAGs, or "none — independent failures">
**Start here:** <the single fix that unblocks the most>
```

> Logs are why this fans out: three DAGs × full task logs would drown one
> context window. Each subagent reads its own logs and returns only a verdict.
