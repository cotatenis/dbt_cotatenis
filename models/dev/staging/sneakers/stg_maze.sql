select 
      payload:product::text as product
    , payload:sku::text as sku
    , payload:brand::text as brand
    , payload:description::text as description
    , payload:has_stock::boolean as is_available
    , payload:stock_info as stock_info
    , payload:price::float as price
    , payload:image_uris as image_uris
    , payload:spider::text spider
    , payload:spider_version::text spider_version
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_source', 'raw_maze') }}