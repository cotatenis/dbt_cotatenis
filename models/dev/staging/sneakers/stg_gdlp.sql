select 
      payload:product::text as product
    , payload:product_info::variant as product_info
    , payload:sku::text as sku
    , payload:genre::text as genre
    , payload:description as description
    , payload:sizes_and_stock::variant as sizes_and_stock
    , payload:reference_first_image::text as reference_first_image
    , payload:image_uris as image_uris
    , payload:image_urls as image_urls
    , payload:spider::text spider
    , payload:spider_version::text spider_version
    , payload:timestamp::timestamp as collected_at
    , payload:url::text as url
FROM {{ source('cotatenis_dev', 'raw_gdlp') }}
WHERE
    payload:sku is not NULL