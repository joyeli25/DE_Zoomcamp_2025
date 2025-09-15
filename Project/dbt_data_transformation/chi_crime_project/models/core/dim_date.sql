{{ config(materialized='table') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(['Date']) }} as date_key,
    cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) as date) as date,
    extract(year from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as year,
    extract(month from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as month,
    extract(day from PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date)) as day,
    format_date('%A', cast(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', Date) as date)) as weekday,
    CASE
        -- Try format: "2024 Jul 24 03:40:48 PM"
        WHEN SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', `Updated On`) IS NOT NULL 
            THEN SAFE.PARSE_TIMESTAMP('%Y %b %d %I:%M:%S %p', `Updated On`)
        -- Try format: "06/21/2025 03:54:42 PM" 
        WHEN SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', `Updated On`) IS NOT NULL
            THEN SAFE.PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', `Updated On`)
        -- Add more format attempts if needed
        ELSE NULL  -- Or handle invalid dates as needed
    END as updated_on
from {{ source('staging', 'chi_crime_all') }}
