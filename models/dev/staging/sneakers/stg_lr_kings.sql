{{ config(materialized='view') }}

with list_of_products as (
    SELECT
          sku
        , split_part(p1.value:element:name::text, '-', 0) AS product
        , CASE brand
            WHEN 'Loja Kings Sneakers' THEN ''
            WHEN 'Adidas' THEN 'adidas'
            WHEN 'aDIDAS' THEN 'adidas'
            WHEN 'ADIDAS' THEN 'adidas'
            WHEN 'Nike' THEN 'Nike'
            ELSE brand
        END
        AS brand
        , description
        , replace(p1.value:element.title, ',', '.') as size
        , p1.value:element:available::boolean AS in_stock
        , price
        , url
        , collected_at
    FROM {{ ref ('stg_kings')}},
    lateral flatten(input => variants) f,
    lateral flatten(input => f.value) p1
) ,  sku_last_result AS (
  SELECT
     DISTINCT s1.sku
    , s2.collected_at as most_recent_timestamp
  FROM
      (
       SELECT
         sku,
         MAX(collected_at) AS collected_at
       FROM
          {{ ref ('stg_kings')}}
       GROUP BY
         sku
      )   AS s2
   INNER JOIN
      {{ ref ('stg_kings')}} as s1
    ON s1.sku = s2.sku
    ORDER BY most_recent_timestamp DESC 
) SELECT
     lp.sku as sku
    , url
    , price
    , product
    , description
    , lp.collected_at as collected_at
    , brand
    , in_stock
    , -1 as qty_stock
    , size
    , 'KINGS' as store
    FROM list_of_products lp
    LEFT JOIN sku_last_result
ON sku_last_result.sku = lp.sku
WHERE sku_last_result.most_recent_timestamp = lp.collected_at