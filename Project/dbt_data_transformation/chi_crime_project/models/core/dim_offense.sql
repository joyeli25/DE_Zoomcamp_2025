{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['iucr', '"fbi code"']) }} as offense_key,
    iucr,
    "primary type" as primary_type,
    description,
    "fbi code" as fbi_code
from {{ source('staging', 'chi_crime_all') }}

