# Project Conventions

## Naming
- **Snake_case** for all column names and model names
- **`stg_` prefix** for staging models (e.g., `stg_customers`, `stg_orders`)
- **`mart_` prefix** for mart models (e.g., `mart_product_sales`, `mart_daily_revenue`)

## CTE Pattern
Every model follows this CTE flow:
1. **Source CTEs** — `select * from {{ ref('stg_...') }}` or `{{ source('raw', '...') }}`
2. **Transformation CTEs** — renamed, filtered, joined as needed
3. **Final CTE** — `final as (select * from <last_cte>)`
4. **Final SELECT** — always `select * from final`

Staging models use: `source → renamed → final`
Mart models use: `<source_refs> → joined/aggregated → final`

## Monetary Values
- All monetary values are **stored as cents** (integers)
- Use the **`cents_to_dollars()`** macro for display conversion: `{{ cents_to_dollars('sum(oi.quantity * oi.unit_price_cents)') }}`
- The macro does: `round(<expr> / 100.0, 2)`

## Materializations
- **Staging models** = `view` (configured in `dbt_project.yml`)
- **Mart models** = `table` (configured in `dbt_project.yml`)

## Testing
- Primary keys: `not_null` + `unique`
- Foreign keys: `not_null`
- All output columns: `not_null`
- Enums/status columns: `accepted_values`
- Documentation: every column gets a `description`

## Sources
- Always use `{{ source('raw', 'table_name') }}` in staging models
- Always use `{{ ref('stg_model_name') }}` in mart models
- Never hardcode table names

## Filtering
- Returned orders (`status = 'returned'`) are excluded from revenue calculations
