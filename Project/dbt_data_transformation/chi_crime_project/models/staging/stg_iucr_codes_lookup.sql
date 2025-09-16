{{
    config(
        materialized='view'
    )
}}


select
    cast(IUCR as string) as iucr,	
    cast("PRIMARY DESCRIPTION" as string) as PRIMARY_DESCRIPTION,
    cast("SECONDARY DESCRIPTION" as string) as SECONDARY_DESCRIPTION,
    cast("INDEX CODE" as string) as INDEX_CODE, 	
    cast(ACTIVE as string) as active
from {{ source('staging','iucr_codes_lookup') }}



-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  limit 100

{% endif %}