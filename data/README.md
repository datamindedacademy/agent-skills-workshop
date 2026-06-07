# Workshop warehouse (`data/`)

The shared dataset for the whole workshop. A tiny dbt project on **DuckDB** that
builds a warehouse of three "data products" and exports a CSV for the warm-up.

## What it produces

| Artifact | Used by |
|---|---|
| `warehouse.duckdb` | Analyst (*Talk to your data*) queries it; Architect (*Checkup*) scores it |
| `sample.csv` (export of `fct_orders`) | The intro warm-up: `/explore-data data/sample.csv` |

Both are **committed**: they're the workshop's source of truth. You normally
don't need to rebuild them.

## Rebuild

```bash
cd data
./build.sh          # dbt build  +  export sample.csv
```

Requires [`uv`](https://docs.astral.sh/uv/). The script pins dbt-core + dbt-duckdb
via `pyproject.toml`, so no global install is needed.

## The data products

- **`dim_customers`**: one row per customer.
- **`fct_orders`**: one row per order, enriched with customer attributes (the warm-up CSV).
- **`customer_order_summary`**: per-customer aggregates.

## Deliberate quality issues

The seed data is *intentionally dirty* so `explore-data` and `checkup` have real
findings:

- **Duplicate key**: `customer_id = 3` appears twice (breaks `unique`, fans out joins).
- **Duplicate** `order_id = 50`.
- **Missing values**: null emails, null order amounts.
- **Placeholder values**: `"N/A"` email.
- **Impossible/future dates**: a 2099 signup date and a 2099 order date.
- **Suspicious numbers**: a negative amount (`-50`) and a `999999` placeholder.
- **Inconsistent encodings**: country as `USA` / `US` / `United States` / `us`.
- **Orphan FK**: `order_id = 44` references `customer_id = 999` (no such customer).

dbt tests are set to `severity: warn` (see `dbt_project.yml`) so `dbt build`
still completes; run `uv run dbt test` to see the issues reported.

**Exception:** on the `prod` target (the scheduled Airflow run on Conveyor,
see `exercises/airflow/demo/dags/workshop_dbt.py`), two tests on `fct_orders` are
strict (`severity: error` via jinja in `models/marts/_marts.yml`). The dirty
data deliberately fails the production pipeline; that failure is the engineer
track's debugging exercise. Local dev builds are unaffected.
