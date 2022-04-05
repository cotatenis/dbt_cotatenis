{{ config(materialized='view') }}

WITH most_recent_records AS (
    SELECT
        DISTINCT
        t1.sku,
        t1.brand,
        t1.product,
        t1.description,
        t1.price,
        t1.url,
        t1.is_available,
        t1.size,
        MAX(t1.collected_at) as collected_at
    FROM (
        SELECT
        DISTINCT
        sku,
        brand,
        product,
        description,
        price,
        url,
        is_available,
        size,
        MAX(collected_at) as collected_at
        FROM
             {{ ref ('stg_farfetch') }}
        WHERE sku is not NULL AND price is not NULL
        GROUP BY sku, brand, product, description, price, url, is_available, size
    ) t1
    INNER JOIN {{ ref ('stg_farfetch') }} as t2
    ON t2.collected_at = t1.collected_at and t2.sku = t1.sku
    WHERE t2.size IS NOT NULL AND t1.description NOT LIKE '%Chinelo%' AND t1.description NOT LIKE '%Chuteira%'
    GROUP BY t1.sku, t1.url, t1.price, t1.product, t1.description, t1.brand, t1.is_available, t1.size
), farfetch_last_records as (
SELECT
    DISTINCT
    sku,
    url,
    price::float as price,
    product,
    description,
    collected_at,
    brand,
    is_available::boolean as in_stock,
    -1 as qty_stock,
    size::float as size,
    'FARFETCH' as store
FROM 
    most_recent_records 
WHERE true
qualify ROW_NUMBER() OVER(PARTITION BY sku, size ORDER BY collected_at DESC) = 1
) SELECT * FROM farfetch_last_records