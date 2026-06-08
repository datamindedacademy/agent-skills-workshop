#!/usr/bin/env bash
# Build the shared workshop warehouse and export the warm-up CSV.
#   data/warehouse.duckdb  the source-of-truth warehouse (committed)
#   data/sample.csv        fct_orders export the warm-up profiles (committed)
set -euo pipefail
cd "$(dirname "$0")"

export DBT_PROFILES_DIR="$(pwd)"

# Tests are warn-severity (see dbt_project.yml), so build always completes
# even though the data is deliberately dirty.
uv run dbt build

uv run python scripts/export_sample.py

echo "Done: warehouse.duckdb + sample.csv"
