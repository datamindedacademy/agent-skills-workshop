with

source as (
    select * from {{ source('raw', 'order_items') }}
),

renamed as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price_cents
    from source
),

final as (
    select * from renamed
)

select * from final
