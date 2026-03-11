with

source as (
    select * from {{ source('raw', 'products') }}
),

renamed as (
    select
        product_id,
        product_name,
        category,
        price_cents
    from source
),

final as (
    select * from renamed
)

select * from final
