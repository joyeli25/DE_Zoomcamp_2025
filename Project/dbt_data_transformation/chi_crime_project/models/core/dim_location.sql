{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['block', 'beat', 'district', 'ward', '"community area"']) }} as location_key,
    block,
    beat,
    district,
    ward,
    "community area" as community_area,
    "location description" as location_description,
    latitude,
    longitude,
    "x coordinate" as x_coordinate,
    "y coordinate" as y_coordinate
from {{ source('staging', 'chi_crime_all') }}
