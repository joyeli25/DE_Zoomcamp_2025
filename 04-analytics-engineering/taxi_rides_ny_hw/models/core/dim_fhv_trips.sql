{{ config(materialized="table") }}

with
    fhv_trip as (
        select
            extract(year from pickup_datetime) as year,
            extract(month from pickup_datetime) as month,
            timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
            pickup_locationid,
            dropoff_locationid
        from {{ ref("stg_fhv_tripdata") }}
        where dispatching_base_num is not null
    )
select distinct
    year,
    month,
    pickup_zone.zone as pickupzone,
    dropoff_zone.zone as dropoffzone,
    percentile_cont(trip_duration, 0.90) over (
        partition by year, month, pickup_locationid, dropoff_locationid
    ) as p90_trip_duration
from fhv_trip
inner join
    `dbt_taxi_hw.dim_zone_lookup` as pickup_zone
    on fhv_trip.pickup_locationid = pickup_zone.locationid
inner join
    `dbt_taxi_hw.dim_zone_lookup` as dropoff_zone
    on fhv_trip.dropoff_locationid = dropoff_zone.locationid
