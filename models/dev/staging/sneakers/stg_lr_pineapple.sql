{{ config(materialized='view') }}

WITH most_recent_records AS (
        SELECT
        DISTINCT
        sku,
        brand,
        product,
        description,
        price,
        url,
        is_available as in_stock,
        size,
        MAX(collected_at) as collected_at
        FROM
             {{ ref ('stg_pineapple') }} as store
        WHERE sku is not NULL AND price is not NULL and size IS NOT NULL AND description NOT LIKE '%Chinelo%' AND description NOT LIKE '%Chuteira%'
        GROUP BY sku, brand, product, description, price, url, is_available, size
)
SELECT
    DISTINCT
    sku,
    url,
    price,
    product,
    description,
    collected_at,
    brand,
    in_stock,
    -1 as qty_stock,
    size,
    'PINEAPPLE' as store
FROM most_recent_records
WHERE true 
qualify ROW_NUMBER() OVER(PARTITION BY sku, size ORDER BY collected_at DESC) = 1