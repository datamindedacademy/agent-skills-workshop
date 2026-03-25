-- Data product: customer dimension.
-- Known issues (deliberate): duplicate customer_id (3), null + "N/A" emails,
-- inconsistent country encodings, one future signup_date.
select
    customer_id,
    first_name,
    last_name,
    email,
    country,
    signup_date
from {{ ref('stg_customers') }}
