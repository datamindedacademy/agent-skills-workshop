# Instructor guide

Everything for running the workshop, kept out of the participants' way:
spoilers, deploy steps, and the Terraform that provisions the Conveyor
environment, project, users, and IDEs (`infra/`).

## Data Engineer track: the staged failure

The scheduled DAG `workshop-dbt-build` (env `workshop`) is **red on
`model.data_warehouse.fct_orders`**, everything upstream green. On the `prod`
target two tests are strict (`severity: error` via jinja in
`data/models/marts/_marts.yml`); the dirty seeds fail them:

| Test | Result | Root cause |
|---|---|---|
| `unique_fct_orders_order_id` | FAIL 3 | `order_id = 50` duplicated |
| `relationships_…_customer_id` | FAIL 1 | `order_id = 44` → `customer_id = 999` (orphan FK) |

`fct_orders` failing leaves `customer_order_summary`/`end` as `upstream_failed`.
Local builds and the analyst/steward tracks see these as `warn` only, so
they're unaffected. The fix is in the dbt project (dedupe the order, resolve or
drop the orphan), then re-run to green.

## Deploy / update the demo

```bash
make manifest                              # after any dbt change
conveyor build && conveyor deploy --env workshop
```

- DAG is `@hourly`, so there's always a recent failed run to triage.
- For a richer `/failure-triage` (fans out per failing DAG), deploy 1-2 extra
  broken DAGs (e.g. a model pointed at a missing seed, or a bad `--target`).
- Verified 2026-06-07 against
  `https://app.conveyordata.com/environments/workshop/airflow` (Airflow 3.1.8):
  `af health` / `dags list` / `runs trigger` work with `conveyor auth get`
  tokens. Verb is `af runs trigger`, not `af dags trigger`.

## Other tracks

Analyst and steward both read the dirty `data/warehouse.duckdb`; the
deliberate quality issues are documented in `data/README.md`.
