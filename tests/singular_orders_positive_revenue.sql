select *
from {{ ref('fct_orders') }}
where price_usd < 0