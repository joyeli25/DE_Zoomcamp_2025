{{ config(materialized="table") }}

with
    quarterly_revenue as (
        select
            service_type,
            extract(year from pickup_datetime) as revenue_year,
            extract(quarter from pickup_datetime) as revenue_quarter,
            sum(total_amount) as quarterly_revenue_amt
        from {{ ref("dim_taxi_trips") }}
        where
            pickup_datetime is not null
            and extract(year from pickup_datetime) in (2019, 2020)
        group by 1, 2, 3
    )

select
    service_type,
    revenue_year,
    revenue_quarter,
    quarterly_revenue_amt,
    lag(quarterly_revenue_amt) over (
        partition by service_type, revenue_quarter order by revenue_year
    ) as prev_year_quarterly_revenue,
    100 * (
        quarterly_revenue_amt - lag(quarterly_revenue_amt) over (
            partition by service_type, revenue_quarter order by revenue_year
        )
    )
    / lag(quarterly_revenue_amt) over (
        partition by service_type, revenue_quarter order by revenue_year
    ) as yoy_growth_percent
from quarterly_revenue
order by 6 desc, 1
