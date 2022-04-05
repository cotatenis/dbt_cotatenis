{{ config(materialized='view') }}

WITH most_recent_records AS (
        SELECT
        DISTINCT
        sku
        , brand
        , product
        , d2.value:element::text as description
        , price::float as price
        , url
        , si1.value as stock_value
        , MAX(collected_at) as collected_at
        FROM
             {{ ref ('stg_shop2gether') }},
        lateral flatten(input=> stock_info) si1,
        lateral flatten(input => parse_json(description)) d1,
        lateral flatten(input => d1.value) d2
        WHERE sku is not NULL AND price is not NULL
        GROUP BY sku, brand, product, d2.value:element, price, url, si1.value
), unnest_fields as (
    SELECT
        DISTINCT
          sku
        , url
        , price
        , product
        , description
        , collected_at
        , brand
        , si3.value:is_in_stock::boolean as in_stock
        , si3.value:qty_stock::float as qty_stock 
        , si3.value:label::float as size
        , 'SHOP2GETHER' as store
    FROM most_recent_records,
    lateral flatten(input=> stock_value) si2,
    lateral flatten(input=> si2.value) si3
    WHERE true 
    qualify ROW_NUMBER() OVER(PARTITION BY sku, size ORDER BY collected_at DESC) = 1
), final_filter as (
    SELECT * 
    FROM unnest_fields 
    WHERE size IS NOT NULL AND description NOT LIKE '%Chinelo%' AND description NOT LIKE '%Chuteira%'

) SELECT * FROM final_filter