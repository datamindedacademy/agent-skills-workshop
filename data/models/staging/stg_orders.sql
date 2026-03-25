-- Light staging: cast types. Status case, null/negative/placeholder amounts,
-- the orphan customer_id and the duplicate order_id are all left intact so the
-- downstream data products have genuine quality issues.
with source as (
    select * from {{ ref('raw_orders') }}
)

select
    order_id,
    customer_id,
    cast(order_date as date) as order_date,
    status,
    cast(amount as double)   as amount
from source
