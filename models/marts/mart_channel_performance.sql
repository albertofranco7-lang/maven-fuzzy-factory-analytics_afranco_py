{{ config(materialized='table') }}

select
    session_date,
    coalesce(utm_source, 'direct') as utm_source,
    coalesce(utm_campaign, 'none') as utm_campaign,
    coalesce(device_type, 'unknown') as device_type,
    count(*) as total_sessions,
    sum(is_converted_session) as converted_sessions,
    sum(order_revenue_usd) as revenue_usd,
    case
        when count(*) = 0 then 0
        else round(1.0 * sum(is_converted_session) / count(*), 4)
    end as conversion_rate
from {{ ref('fct_website_sessions') }}
group by 1,2,3,4
order by 1,2,3,4