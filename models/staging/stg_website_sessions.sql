{{ config(materialized='view') }}

with source as (

    select * from {{ source('airbyte_curso', 'website_sessions') }}

)

select
    website_session_id,
    created_at,
    user_id,
    is_repeat_session,
    case
        when utm_source is null or trim(utm_source) = '' then 'direct'
        else trim(lower(utm_source))
    end as utm_source,
    utm_campaign,
    utm_content,
    device_type,
    http_referer,
    cast(created_at as date) as session_date
from source