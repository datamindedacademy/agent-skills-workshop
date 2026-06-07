---
name: talk-to-your-data
description: >
  Answer plain-language questions about the workshop warehouse by writing and
  running SQL against the DuckDB database. Use when asked anything about
  customers, orders, revenue, countries, trends, or "how many / what is the
  total / top N" questions on the data: translates the question to SQL,
  runs it read-only, and explains the result.
allowed-tools: Bash
---

# Talk to your data

Turn a plain-language question into SQL, run it **read-only** against the
warehouse, and explain the answer like a colleague would.

## Warehouse schema (live)

!`duckdb -readonly ../../data/warehouse.duckdb -c "SHOW ALL TABLES;"`

## Rules for querying

1. **Database:** `../../data/warehouse.duckdb`. Always run read-only:
   ```bash
   duckdb -readonly ../../data/warehouse.duckdb -c "<SQL>"
   ```
2. **Query the marts**, not the raw/staging tables: `dim_customers`,
   `fct_orders`, `customer_order_summary`. Raw and staging tables exist but are
   plumbing.
3. **This warehouse has known quirks: handle them, and say so:**
   - `status` has mixed casing (`completed` vs `Completed`, `CANCELLED` vs
     `cancelled`). Always compare with `lower(status)`.
   - `country` is unstandardized (`USA`/`US`/`us`, `BE`/`Belgium`, `NULL`).
     Group on raw values only if asked; otherwise note the variants.
   - `amount` contains an obvious outlier (`999999`) and `order_date` contains
     a future date (`2099-01-01`). When computing totals/averages or date
     ranges, mention whether outliers are included and offer the filtered
     number too.
4. One question may need more than one query: run what you need, but keep it
   to the few queries that answer the question.

## Output format

```
**Answer:** <one-sentence plain-language answer with the number(s)>

```sql
<the SQL you ran>
```

| <result table, max ~10 rows> |

**Caveats:** <data quirks that affect this answer: casing, outliers,
country variants, or "none">
```

Never modify the database. If asked to change data, explain it's read-only.
