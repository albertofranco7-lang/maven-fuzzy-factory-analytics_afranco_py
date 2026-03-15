{{ config(materialized='view') }}

SELECT *
FROM {{ source('airbyte_curso', 'orders') }}