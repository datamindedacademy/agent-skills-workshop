# Production demo: facilitator notes

The DAG participants operate (`workshop-dbt-build` in the `workshop` Airflow
environment) is deployed from the **repo root**, which is itself a Conveyor
project:

| Piece | Where |
|---|---|
| Conveyor project config | `.conveyor/project.yaml` (project `agent-skills-workshop`) |
| DAG | `dags/workshop_dbt.py`: `ConveyorDbtTaskFactory`, one task per dbt model |
| dbt manifest the factory reads | `dags/manifest.json`: regenerate with `make manifest` |
| Container | `Dockerfile`: the `data/` dbt project on the dataminded dbt image |

## Deploying / updating

```bash
make manifest   # after any dbt model change
conveyor build && conveyor deploy --env workshop
```

## How the failure is staged

Each task runs `dbt build --target prod --select +<model>` in an ephemeral
container (DuckDB is rebuilt from seeds every task). On the `prod` target two
tests on `fct_orders` are strict (`severity: error`, see
`data/models/marts/_marts.yml`) and fail on the deliberately dirty seeds:

- `unique_fct_orders_order_id` → FAIL 3 (duplicate order_id 50)
- `relationships_…_customer_id` → FAIL 1 (orphan customer_id 999)

So every run goes: staging + dims green, **`model.data_warehouse.fct_orders`
red**: with the test failures sitting in that task's logs for participants'
`/airflow-ops` and `/failure-triage` skills to find. Local builds
(`data/build.sh`, dev target) only warn, so the other tracks are unaffected.

## Before the workshop

- The DAG is `@hourly`, so there's always a recent failed run to triage.
- For a richer `/failure-triage` (it fans out per failing DAG), deploy 1–2
  extra broken DAGs: e.g. copy the DAG with a `--select` of a model you've
  pointed at a missing seed, or add a task with a bad `--target`.
- Verified 2026-06-07: `af health`/`dags list`/`runs trigger` work against
  `https://app.conveyordata.com/environments/workshop/airflow` with
  `conveyor auth get` tokens (Airflow 3.1.8). Note: it's `af runs trigger`,
  not `af dags trigger`.
