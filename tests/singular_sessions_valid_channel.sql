select *
from {{ ref('fct_website_sessions') }}
where utm_source is not null
  and utm_source not in ('gsearch', 'bsearch', 'socialbook', 'direct')