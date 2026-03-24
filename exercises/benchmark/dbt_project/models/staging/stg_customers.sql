with

source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        created_at
    from source
),

final as (
    select * from renamed
)

select * from final
