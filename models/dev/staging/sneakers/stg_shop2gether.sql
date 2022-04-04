with parse_prices as (
    SELECT 
      payload:product::text as product
    , payload:brand::text as brand
    , payload:usku::text as sku
    , payload:description::text as description
    , replace(payload:price, ',', '.')::float as price
    , payload:stock_info::variant as stock_info
    , payload:reference_first_image::text as reference_first_image
    , payload:image_uris as image_uris
    , payload:spider::text spider
    , payload:spider_version::text spider_version
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_source', 'raw_shop2gether') }}
) 
    SELECT * FROM parse_prices
    WHERE price is not NULL 
    AND sku is not NULL
    and stock_info is not NULL