{{ config(materialized='view') }}

select *
from {{ source('airbyte_curso', 'products') }}