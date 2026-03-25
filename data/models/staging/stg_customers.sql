-- Light staging: trim names, cast the date. Country, email and the duplicate
-- key are left untouched on purpose so the marts (and the warm-up CSV) still
-- carry realistic quality issues for explore-data / checkup to surface.
with source as (
    select * from {{ ref('raw_customers') }}
)

select
    customer_id,
    trim(first_name)        as first_name,
    trim(last_name)         as last_name,
    email,
    country,
    cast(signup_date as date) as signup_date
from source
