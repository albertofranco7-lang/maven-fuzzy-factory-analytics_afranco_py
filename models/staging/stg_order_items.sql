{{ config(materialized='view') }}

SELECT * FROM {{ source('airbyte_curso', 'order_items') }}