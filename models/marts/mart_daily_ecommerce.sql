{{ config(materialized='table') }}

with sessions as (

    select
        session_date,
        count(*) as total_sessions,
        sum(is_converted_session) as converted_sessions,
        sum(order_revenue_usd) as revenue_usd
    from {{ ref('fct_website_sessions') }}
    group by 1

),

orders as (

    select
        order_date,
        count(*) as total_orders,
        sum(items_purchased) as total_items,
        avg(price_usd) as avg_order_value_usd
    from {{ ref('fct_orders') }}
    group by 1

)

select
    coalesce(s.session_date, o.order_date) as metric_date,
    coalesce(s.total_sessions, 0) as total_sessions,
    coalesce(s.converted_sessions, 0) as converted_sessions,
    coalesce(o.total_orders, 0) as total_orders,
    coalesce(o.total_items, 0) as total_items,
    coalesce(s.revenue_usd, 0) as revenue_usd,
    coalesce(o.avg_order_value_usd, 0) as avg_order_value_usd,
    case
        when coalesce(s.total_sessions, 0) = 0 then 0
        else round(1.0 * coalesce(s.converted_sessions, 0) / s.total_sessions, 4)
    end as conversion_rate
from sessions s
full outer join orders o
    on s.session_date = o.order_date
order by 1