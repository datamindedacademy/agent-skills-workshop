# The production demo: `workshop-dbt-build`

This folder holds the real DAG you operate in the engineer track. It is the
workshop warehouse's dbt build, scheduled in production on Conveyor Airflow.
Read it here, or just point your agent at this folder: *"read
`exercises/airflow/demo/` and tell me what this pipeline does and why it
fails."*

## What it is

| Piece | Where |
|---|---|
| DAG | `dags/workshop_dbt.py` (this folder): `ConveyorDbtTaskFactory`, one Airflow task per dbt model |
| dbt manifest the factory reads | `dags/manifest.json` (this folder): regenerate with `make manifest` at the repo root |
| Conveyor project config | `.conveyor/project.yaml` at the repo root (project `agent-skills-workshop`; its workflows path points here) |
| Container | `Dockerfile` at the repo root: the `data/` dbt project on the dataminded dbt image |

`ConveyorDbtTaskFactory` turns the dbt graph into Airflow tasks: `start` →
one task per model (`stg_customers`, `stg_orders`, `dim_customers`,
`fct_orders`, `customer_order_summary`) → `end`. Each task runs
`dbt build --target prod --select +<model>` in its own ephemeral container, so
it rebuilds its whole lineage from the seeds (the DuckDB file does not persist
between tasks).

## What is wrong with it (the thing you debug)

The run is **red on `model.data_warehouse.fct_orders`**; everything upstream is
green. On the `prod` target two tests on `fct_orders` are strict
(`severity: error`, set with jinja in `data/models/marts/_marts.yml`) and the
deliberately dirty seed data fails them:

| Test | Result | Root cause in the seed data |
|---|---|---|
| `unique_fct_orders_order_id` | FAIL 3 | `order_id = 50` is duplicated |
| `relationships_fct_orders_customer_id__…` | FAIL 1 | `order_id = 44` points at `customer_id = 999`, which has no row in `dim_customers` (orphan FK) |

`fct_orders` failing leaves `customer_order_summary`/`end` as
`upstream_failed`. The failure is by design: it is what your `/airflow-ops` and
`/failure-triage` skills are meant to surface from the task logs. Everywhere
else (local `data/build.sh`, the analyst and architect tracks) these same
issues are only `severity: warn`, so they do not block anything.

## Facilitator notes

- Deploy/update: `make manifest` (after any dbt change), then
  `conveyor build && conveyor deploy --env workshop`.
- The DAG is `@hourly`, so there is always a recent failed run to triage.
- For a richer `/failure-triage` (it fans out one subagent per failing DAG),
  deploy 1-2 extra broken DAGs: e.g. copy the DAG selecting a model pointed at
  a missing seed, or add a task with a bad `--target`.
- Verified 2026-06-07 against
  `https://app.conveyordata.com/environments/workshop/airflow` (Airflow 3.1.8):
  `af health` / `af dags list` / `af runs trigger` work with `conveyor auth get`
  tokens. Note the verb is `af runs trigger`, not `af dags trigger`.
