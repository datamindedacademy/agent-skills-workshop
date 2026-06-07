---
name: failure-triage
# TODO 1: Write the description. It should trigger when someone asks "what's
# broken", "triage the failures", or wants an incident overview ACROSS DAGs
# (not a single run: that's what airflow-ops is for).
description: TODO
# TODO 2: This skill runs a CLI AND dispatches subagents. Which tools does it
# need? (hint: one of them lets you launch subagents.)
allowed-tools: TODO
---

# Failure Triage (subagents)

Diagnose **every failing DAG in parallel** and synthesize one incident summary.

## When to fan out: read this first

- **One** failed run is a single quick pass → just diagnose it with `/airflow-ops`.
- **Several** DAGs failing is independent, log-heavy work: full task logs would
  flood a single context window: exactly when subagents pay off.

If only one DAG failed, you would **not** use subagents: the overhead (latency,
tokens, coordination) isn't worth it. *That* is the judgment this skill teaches.

## Steps

1. TODO 3: Find what's failing: list the DAGs, check each one's latest runs,
   keep those whose latest run failed (reuse the connection recipe from
   `/airflow-ops`). What should happen if NOTHING is failing?

2. TODO 4: Dispatch **one subagent per failed DAG, in parallel** (a single
   message with multiple Task calls: not one after another).
   <!--
   Write the subagent prompt as a template with the DAG id and run id filled in.
   Each subagent should:
     - run `af runs diagnose` and pull the failed task's logs
     - find the ROOT CAUSE, not the symptom
     - return compact JSON: dag, run, failed_task, root_cause, evidence,
       suggested_fix, severity
   Returning compact JSON instead of raw logs is the point: each subagent
   reads its own logs and sends back only a verdict.
   -->

3. TODO 5: Synthesize the verdicts into one **incident summary**, ranked by
   severity. Look for failures sharing a root cause (one upstream outage can
   break three DAGs): that cross-DAG link is the thing no single subagent
   can see.

## Output format

<!--
TODO 6: Specify the incident summary: a table of DAG | failed task |
root cause | severity | suggested fix, plus a "common cause" line and the
single fix to start with.
-->
