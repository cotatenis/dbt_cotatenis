select 
      payload:product::text as product
    , payload:brand::text as brand
    , payload:sku::text as sku
    , payload:description::text as description
    , payload:in_stock::boolean as is_available
    , payload:price::float as price
    , payload:size::float as size
    , payload:img_search_page::text as reference_first_image
    , payload:image_uris as image_uris
    , payload:spider::text spider
    , payload:spider_version::text spider_version
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_source', 'raw_farfetch') }}
WHERE 
    payload:price is not null AND 
    payload:sku is not null AND
    payload:spider is not null AND
    payload:spider_version is not null 
