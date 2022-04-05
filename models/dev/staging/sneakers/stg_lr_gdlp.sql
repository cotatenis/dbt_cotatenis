{{ config(materialized='view') }}

WITH col_format AS (
    SELECT
        DISTINCT
          t1.sku
        , t1.url
        , t1.price
        , t1.product
        , t1.brand
        , t1.size
        , t1.in_stock
        , t1.description
        , t1.collected_at
    FROM (
            SELECT
                 DISTINCT
                      sku
                    , url
                    , prdi_2.value:element:productPrice::float as price
                    , prdi_2.value:element:productName::text as product
                    , prdi_2.value:element:categoryName::text as brand
                    , d2.value:element::text as description
                    , ss3.value:in_stock::boolean as in_stock
                    , ss3.value:size::float as size
                    , collected_at
            FROM {{ ref ('stg_gdlp') }} as store,
            lateral flatten(input => sizes_and_stock) ss1,
            lateral flatten(input => ss1.value) ss2,
            lateral flatten(input => ss2.value) ss3,
            lateral flatten(input => product_info) prdi_1,
            lateral flatten(input => prdi_1.value) prdi_2,
            lateral flatten(input => parse_json(description)) d1,
            lateral flatten(input => d1.value) d2
            WHERE prdi_2.value:element:productName NOT LIKE '%CHINELO%'
            AND ss3.value:size is NOT NULL
      ) t1
), most_recent_records as (
    SELECT * 
    FROM (
        SELECT
          DISTINCT sku
        , url
        , price
        , product
        , brand
        , description
        , size
        , in_stock
        , MAX(collected_at) as collected_at
    FROM col_format
    GROUP BY sku, url, price, product, brand, description, size, in_stock
    ) 
) SELECT 
      SUBSTR(sku, 0, 6) as sku
    , url
    , price
    , product
    , description
    , collected_at
    , brand
    , in_stock
    , -1 as qty_stock
    , size
    , 'GDLP' as store
    FROM most_recent_records
    where true
    qualify ROW_NUMBER() OVER(PARTITION BY sku, size ORDER BY collected_at DESC) = 1