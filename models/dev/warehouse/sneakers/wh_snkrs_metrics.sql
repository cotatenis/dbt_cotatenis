
{{ config(materialized='view') }}

with price_stats as (
    SELECT distinct brand, min(price) lowest_price, max(price) as maximum_price, avg(price) average_price, median(price) as median_price FROM {{ ref('wh_lr_snkrs') }} GROUP BY brand
), max_prices_per_brand as (
    select brand, max(price) as maximum_price from {{ ref('wh_lr_snkrs') }} group by brand
), inter_join as (
    SELECT sku, product, t1.brand, store from {{ ref('wh_lr_snkrs') }} t1
    INNER JOIN max_prices_per_brand t2 
    ON t2.maximum_price = t1.price AND t2.brand = t1.brand
), distinct_values as (
    SELECT distinct sku, brand FROM {{ ref('wh_lr_snkrs') }}
), number_of_products_per_brand as (
    SELECT brand, count(brand) as number_of_products from distinct_values group by brand
)
SELECT
    t1.brand
  , number_of_products
  , lowest_price
  , maximum_price
  , round(average_price, 2) as average_price
  , median_price
  , sku as sku_highest_price
  , product as product_highest_price
  , store as store_highest_price
  FROM price_stats t1
  INNER JOIN inter_join t2
  ON t2.brand = t1.brand
  INNER JOIN number_of_products_per_brand t3
  ON t3.brand = t1.brand