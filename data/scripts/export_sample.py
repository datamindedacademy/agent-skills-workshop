"""Export the fct_orders data product to data/sample.csv for the warm-up.

Run after `dbt build` (see build.sh). Uses the same duckdb that dbt-duckdb
wrote the file with, so storage versions always match.
"""

import duckdb

con = duckdb.connect("warehouse.duckdb", read_only=True)
con.execute(
    "COPY (SELECT * FROM fct_orders ORDER BY order_id) "
    "TO 'sample.csv' (HEADER, DELIMITER ',')"
)
rows = con.execute("SELECT count(*) FROM fct_orders").fetchone()[0]
print(f"Exported sample.csv ({rows} rows from fct_orders)")
