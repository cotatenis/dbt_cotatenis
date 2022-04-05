# A dbt project for `cotatenis`

`cotatenis` was a search engine for sneaker's best prices in the Brazilian market.  This repository is a proposal to use the data from this project with [dbt](https://www.getdbt.com/) and [snowflake](https://www.snowflake.com/).

## 1. sources (`models/dev/staging/sneakers/`)
- `raw_farfetch`
- `raw_gdlp`
- `raw_kings`
- `raw_maze`
- `raw_pineapple`
- `raw_shop2gether`

## 2. models
### 2.1 staging (`models/dev/staging/sneakers/`)
- `stg_kings`
- `stg_maze`
- `stg_farfetch`
- `stg_gdlp`
- `stg_pineapple`
- `stg_shop2gether`
- `stg_lr_kings`
- `stg_lr_maze`
- `stg_lr_farfetch`
- `stg_lr_gdlp`
- `stg_lr_pineapple`
- `stg_lr_shop2gether`

### 2.2 warehouse (`models/dev/warehouse/sneakers/`)
- `wh_lr_snkrs`
- `wh_snkrs_metrics`
