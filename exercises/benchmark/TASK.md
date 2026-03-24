# Task: Create mart_customer_orders

Create a new dbt mart model called `mart_customer_orders` with the following columns:

| Column | Type | Description |
|--------|------|-------------|
| customer_id | integer | Unique customer identifier |
| total_orders | integer | Total number of orders placed |
| total_revenue | numeric | Total revenue in dollars |
| first_order_date | date | Date of first order |
| last_order_date | date | Date of most recent order |

Requirements:
- Follow existing project conventions
- Add appropriate tests (not_null, unique on customer_id)
- Add column documentation in schema YAML
- Model must pass `dbt build`
