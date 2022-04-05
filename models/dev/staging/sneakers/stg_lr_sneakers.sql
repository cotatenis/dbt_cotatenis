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

