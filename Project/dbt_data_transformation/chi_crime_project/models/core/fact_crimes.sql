{{ config(materialized='table') }}

select
    {{ dbt_utils.generate_surrogate_key(['id']) }} as crime_id,
    `case number` as case_number,
    d.offense_key,
    l.location_key,
    dt.date_key,
    arrest,
    domestic
from {{ source('staging', 'chi_crime_all') }} s
left join {{ ref('dim_offense') }} d
  on {{ dbt_utils.generate_surrogate_key(['s.iucr', 's.`fbi code`']) }} = d.offense_key
left join {{ ref('dim_location') }} l
  on {{ dbt_utils.generate_surrogate_key(['s.block', 's.beat', 's.district', 's.ward', 's.`community area`']) }} = l.location_key
left join {{ ref('dim_date') }} dt
  on {{ dbt_utils.generate_surrogate_key(['s.date']) }} = dt.date_key
