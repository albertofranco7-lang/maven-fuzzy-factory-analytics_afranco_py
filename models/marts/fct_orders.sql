{{ config(materialized='table') }}

select
    o.order_id,
    o.created_at as order_created_at,
    cast(o.created_at as date) as order_date,
    o.website_session_id,
    o.user_id,
    o.primary_product_id,
    p.product_name as primary_product_name,
    o.items_purchased,
    o.price_usd
from {{ ref('stg_orders') }} o
left join {{ ref('stg_products') }} p
    on o.primary_product_id = p.product_id