-- Data product: per-customer order summary (a small aggregate mart).
-- Inherits upstream issues: customers with no orders show order_count = 0,
-- null amounts are ignored by sum(), and the duplicate customer_id inflates
-- its row. A third "data product" for the steward's portfolio fan-out.
select
    c.customer_id,
    c.country,
    count(o.order_id)   as order_count,
    sum(o.amount)       as total_amount,
    max(o.order_date)   as last_order_date
from {{ ref('stg_customers') }} c
left join {{ ref('stg_orders') }} o
    on c.customer_id = o.customer_id
group by 1, 2
