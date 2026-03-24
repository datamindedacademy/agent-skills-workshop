with

orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

completed_orders as (
    select
        o.order_id,
        o.order_date
    from orders o
    where o.status != 'returned'
),

joined as (
    select
        co.order_date,
        count(distinct co.order_id) as total_orders,
        sum(oi.quantity) as total_items,
        {{ cents_to_dollars('sum(oi.quantity * oi.unit_price_cents)') }} as total_revenue
    from completed_orders co
    left join order_items oi on co.order_id = oi.order_id
    group by 1
),

final as (
    select * from joined
)

select * from final
