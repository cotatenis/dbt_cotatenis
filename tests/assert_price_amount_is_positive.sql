select
    sku,
    price
from {{ ref('wh_lr_snkrs' )}}
where not(price >= 0)