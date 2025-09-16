{{ config(materialized='table') }}

-- select 
--     IUCR,	
--     "PRIMARY DESCRIPTION" as PRIMARY_DESCRIPTION,
--     "SECONDARY DESCRIPTION" as SECONDARY_DESCRIPTION,
--     "INDEX CODE" as INDEX_CODE, 	
--     ACTIVE
-- from {{ ref('iucr_code_lookup') }}

SELECT *
FROM {{ ref('stg_iucr_codes_lookup') }}
