with

products as (
    select * from {{ ref('stg_products') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

joined as (
    select
        p.product_id,
        p.product_name,
        p.category,
        count(distinct oi.order_id) as total_orders,
        sum(oi.quantity) as total_units_sold,
        {{ cents_to_dollars('sum(oi.quantity * oi.unit_price_cents)') }} as total_revenue
    from order_items oi
    left join products p on oi.product_id = p.product_id
    left join orders o on oi.order_id = o.order_id
    where o.status != 'returned'
    group by 1, 2, 3
),

final as (
    select * from joined
)

select * from final
