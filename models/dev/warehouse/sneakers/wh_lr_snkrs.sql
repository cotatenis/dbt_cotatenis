with cleansing_brand_names as (
    SELECT * FROM {{ ref('stg_lr_farfetch')}}
    UNION ALL
    SELECT * FROM {{ ref('stg_lr_gdlp')}}
    UNION ALL
    SELECT * FROM {{ ref('stg_lr_kings')}}
    UNION ALL
    SELECT * FROM {{ ref('stg_lr_maze')}}
    UNION ALL
    SELECT * FROM {{ ref('stg_lr_pineapple')}}
    UNION ALL
    SELECT * FROM {{ ref('stg_lr_shop2gether')}}
) 
    SELECT 
          sku
        , url
        , price
        , product
        , description
        , collected_at
        , CASE
            WHEN brand = 'adidas YEEZY' then 'adidas'
            WHEN brand = 'adidas by Pharrell Williams' then 'adidas'
            WHEN brand = 'Nike X Off-White' then 'Nike'
            WHEN brand = 'ADIDAS' then 'adidas'
            WHEN brand = 'Adidas Y-3' then 'adidas'
            WHEN brand = 'Air Jordan' then 'Jordan'
            WHEN brand = 'Adidas' then 'adidas'
            WHEN brand = 'NIKE' then 'Nike'
            WHEN brand = 'adidas by Stella McCartney' then 'adidas'
            WHEN brand = 'Adidas Consortium' then 'adidas'
            WHEN brand = 'ADIDAS ORIGINALS' then 'adidas'
            ELSE brand
          END as brand
        , in_stock
        , qty_stock
        , size
        , store
    FROM cleansing_brand_names
    WHERE brand != ''

