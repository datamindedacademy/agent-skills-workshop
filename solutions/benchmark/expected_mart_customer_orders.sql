-- This is ONE valid solution. Your skill may differ and still be effective.

with

customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

customer_orders as (
    select
        c.customer_id,
        count(distinct o.order_id) as total_orders,
        {{ cents_to_dollars('sum(oi.quantity * oi.unit_price_cents)') }} as total_revenue,
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date
    from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join order_items oi on o.order_id = oi.order_id
    where o.status != 'returned'
    group by 1
),

final as (
    select * from customer_orders
)

select * from final
