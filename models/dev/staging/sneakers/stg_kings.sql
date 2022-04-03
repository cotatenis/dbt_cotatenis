select 
      payload:title::text as product
    , payload:sku::text as sku
    , payload:description as description
    , payload:available::boolean as is_available
    , payload:price::float as price
    , payload:created_at::timestamp as created_at
    , payload:published_at::timestamp as published_at
    , payload:reference_first_image::text as reference_first_image
    , payload:image_uris as image_uris
    , payload:spider::text spider
    , payload:spider_version::text spider_version
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_source', 'raw_kings') }}