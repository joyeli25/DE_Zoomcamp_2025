{{ config(materialized="table") }}

with
    monthly_data as (
        select
            service_type,
            extract(year from pickup_datetime) as year,
            extract(month from pickup_datetime) as month,
            fare_amount
        from {{ ref("dim_taxi_trips") }}
        where
            fare_amount > 0
            and trip_distance > 0
            and payment_type_description in ('Cash', 'Credit card')
            and extract(year from pickup_datetime) in (2019, 2020)
    )
select distinct
    service_type,
    year,
    month,
    -- continuous percentiles
    percentile_cont(fare_amount, 0.90) over (
        partition by service_type, year, month
    ) as p90_fare,
    percentile_cont(fare_amount, 0.95) over (
        partition by service_type, year, month
    ) as p95_fare,
    percentile_cont(fare_amount, 0.97) over (
        partition by service_type, year, month
    ) as p97_fare
from monthly_data
