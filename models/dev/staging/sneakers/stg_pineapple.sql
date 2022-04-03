select 
      payload:product::text as product
    , payload:brand::text as brand
    , payload:sku::text as sku
    , payload:description as description
    , payload:in_stock::boolean as is_available
    , payload:price::float as price
    , payload:size::float as size
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_source', 'raw_pineapple') }}