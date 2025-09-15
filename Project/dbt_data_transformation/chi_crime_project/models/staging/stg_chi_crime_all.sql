{{
    config(
        materialized='view'
    )
}}


select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['ID', '"Case Number"', 'Date']) }} as crime_id,
    safe_cast(ID as INT64) as id,
    cast("Case Number" as string) as case_number,
    
    -- year field
    safe_cast(Year as INT64) as year,
    
    -- timestamps
    cast(Date as timestamp) as crime_date,
    cast("Updated On" as timestamp) as updated_on,

    -- crime details
    cast(Block as string) as block,
    cast(IUCR as string) as iucr,
    cast("Primary Type" as string) as primary_type,
    cast(Description as string) as description,
    cast("Location Description" as string) as location_description,

    -- boolean flags
    safe_cast(Arrest as boolean) as arrest,
    safe_cast(Domestic as boolean) as domestic,

    -- geographic / jurisdiction info
    safe_cast(Beat as INT64) as beat,
    safe_cast(District as INT64) as district,
    safe_cast(Ward as INT64) as ward,
    safe_cast("Community Area" as INT64) as community_area,

    -- FBI classification
    cast("FBI Code" as string) as fbi_code,

    -- coordinates
    safe_cast("X Coordinate" as numeric) as x_coordinate,
    safe_cast("Y Coordinate" as numeric) as y_coordinate,
    safe_cast(Latitude as numeric) as latitude,
    safe_cast(Longitude as numeric) as longitude,
    cast(Location as string) as location
from {{ source('staging','chi_crime_all') }}



-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  limit 100

{% endif %}