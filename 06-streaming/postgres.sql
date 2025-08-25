CREATE TABLE green_trips_aggregated (
    pickup_date TIMESTAMP,
    PULocationID INT,
    DOLocationID INT,
    cnt BIGINT,
    window_start TIMESTAMP,
    window_end TIMESTAMP
);

-- Add unique constraint to match Flink's primary key definition
ALTER TABLE green_trips_aggregated 
ADD CONSTRAINT green_trips_aggregated_unique 
UNIQUE (PULocationID, DOLocationID);

CREATE TABLE green_trips (
    lpep_pickup_datetime TIMESTAMP,
    lpep_dropoff_datetime TIMESTAMP,
    PULocationID INT,
    DOLocationID INT,
    passenger_count INT,
    trip_distance FLOAT,
    tip_amount FLOAT
);

DROP TABLE IF EXISTS processed_green_trips;

-- use timestamptz if you intend to store the +00 value you’re sending
CREATE TABLE processed_green_trips (
  pickup_datetime   timestamptz,
  PULocationID      int    NOT NULL,
  DOLocationID      int    NOT NULL,
  PRIMARY KEY (PULocationID, DOLocationID)
);


select count(*) from processed_green_trips


select count(*) from green_trips


select pickup_datetime::date as pickup_datetime,
--extract(day from lpep_pickup_datetime) as date,
PULocationid,
dolocationid,
row_number(*)over(partition by PULocationid, dolocationid order by to_char(pickup_datetime, 'YYYY-MM-DD')) as rk
--cast(to_char(lpep_pickup_datetime, 'YYYY-MM-DD') as bigint) - row_number(*)over(partition by PULocationid, dolocationid order by to_char(lpep_pickup_datetime, 'YYYY-MM-DD')) as diff
from processed_green_trips 
--group by 1,2,3 
limit 10


