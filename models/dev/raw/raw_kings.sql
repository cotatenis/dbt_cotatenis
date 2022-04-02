with raw_kings as (
    select * from {{ source('cotatenis_dev', 'raw_kings') }}
) SELECT * FROM raw_kings