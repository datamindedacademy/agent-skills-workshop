with

source as (
    select * from {{ source('raw', 'payments') }}
),

renamed as (
    select
        payment_id,
        order_id,
        payment_method,
        amount_cents,
        created_at
    from source
),

final as (
    select * from renamed
)

select * from final
