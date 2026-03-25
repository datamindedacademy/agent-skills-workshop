-- Data product: order fact, enriched with customer attributes.
-- This is the table exported to data/sample.csv for the warm-up.
-- Known issues (deliberate): null / negative / 999999 amounts, mixed-case
-- status, a future order_date, an orphan customer_id (999 -> null country),
-- and row fan-out for customer 3 (duplicate dimension key) plus a duplicate
-- order_id (50) — realistic landmines for explore-data to flag.
select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    o.amount,
    c.country     as customer_country,
    c.signup_date as customer_signup_date
from {{ ref('stg_orders') }} o
left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id
