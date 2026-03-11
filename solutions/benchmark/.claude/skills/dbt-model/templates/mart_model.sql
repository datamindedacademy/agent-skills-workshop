-- Mart model template
-- Follow this pattern when creating new mart models

with

-- Step 1: Reference staging models
<source_model_1> as (
    select * from {{ ref('stg_<source_1>') }}
),

<source_model_2> as (
    select * from {{ ref('stg_<source_2>') }}
),

-- Step 2: Join and aggregate
joined as (
    select
        -- primary key / group by columns
        <pk_column>,

        -- aggregated metrics
        count(distinct <count_column>) as <metric_name>,
        sum(<sum_column>) as <sum_metric>,

        -- monetary values: use cents_to_dollars macro
        {{ cents_to_dollars('sum(<quantity> * <price_cents>)') }} as <revenue_column>,

        -- date aggregations
        min(<date_column>) as first_<date_column>,
        max(<date_column>) as last_<date_column>

    from <base_table> t1
    left join <joined_table> t2 on t1.<join_key> = t2.<join_key>
    where t1.status != 'returned'  -- exclude returned orders
    group by 1
),

final as (
    select * from joined
)

select * from final
