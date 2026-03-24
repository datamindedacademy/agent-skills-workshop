with

source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_date,
        status
    from source
),

final as (
    select * from renamed
)

select * from final
