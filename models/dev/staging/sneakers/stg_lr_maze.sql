{{ config(materialized='view') }}

with most_recent_data AS  (
SELECT
     DISTINCT sku
    , brand
    , product
    , description
    , l4.value:element.Name as size
    , l4.value:element.Sku:Visible::boolean as in_stock
    , price
    , url
    , MAX(collected_at) as collected_at
FROM 
    {{ ref ('stg_maze') }},
    lateral flatten(input=> stock_info) json,
    lateral flatten(input=> json.value) l2,
    lateral flatten(input=> l2.value:element:Variations) l3,
    lateral flatten(input=> l3.value) l4
WHERE 
    product NOT LIKE '%Chinelo%' 
    AND l4.value:element.Name is NOT NULL 
    AND l4.value:element.Name not in ('PP', 'P', 'M', 'G', 'GG', 'PPP') 
GROUP BY 
    sku, brand, product, description, size, in_stock, price, url
), maze_last_records as ( 
    SELECT 
          t1.sku
        , t1.url
        , t1.price
        , t1.product
        , t1.description
        , t1.collected_at
        , t1.brand
        , t1.in_stock
        , -1 as qty_stock
        , t1.size::float as size
        , 'MAZE' as store
    FROM most_recent_data t1
    INNER JOIN stg_maze t2
    ON t2.collected_at = t1.collected_at 
    AND t2.sku = t1.sku
) 
    SELECT * 
    FROM maze_last_records
    where true
    qualify ROW_NUMBER() OVER(PARTITION BY sku, size ORDER BY collected_at DESC) = 1