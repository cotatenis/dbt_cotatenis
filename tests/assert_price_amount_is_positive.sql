-- test if all records has positive values for the price field
select
    sku,
    price
from {{ ref('wh_lr_snkrs' )}}
where not(price >= 0)