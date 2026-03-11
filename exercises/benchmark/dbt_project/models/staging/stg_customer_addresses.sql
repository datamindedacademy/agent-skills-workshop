with

source as (
    select * from {{ source('raw', 'customer_addresses') }}
),

renamed as (
    select
        address_id,
        customer_id,
        street,
        city,
        state,
        zip_code,
        is_primary
    from source
),

final as (
    select * from renamed
)

select * from final
