{{ config(materialized='table') }}

with sessions as (

    select
        website_session_id,
        created_at as session_created_at,
        cast(created_at as date) as session_date,
        user_id,
        is_repeat_session,
        utm_source,
        utm_campaign,
        utm_content,
        device_type,
        http_referer
    from {{ ref('stg_website_sessions') }}

),

orders as (

    select
        order_id,
        website_session_id,
        price_usd,
        items_purchased
    from {{ ref('stg_orders') }}

)

select
    s.website_session_id,
    s.session_created_at,
    s.session_date,
    s.user_id,
    s.is_repeat_session,
    s.utm_source,
    s.utm_campaign,
    s.utm_content,
    s.device_type,
    s.http_referer,
    o.order_id,
    case when o.order_id is not null then 1 else 0 end as is_converted_session,
    coalesce(o.price_usd, 0) as order_revenue_usd,
    coalesce(o.items_purchased, 0) as items_purchased
from sessions s
left join orders o
    on s.website_session_id = o.website_session_id