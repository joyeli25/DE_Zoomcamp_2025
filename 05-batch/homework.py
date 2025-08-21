#!/usr/bin/env python
# coding: utf-8


import pyspark
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext


# Create a local Spark session
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()


# Execute spark.version
print(f"Spark version: {spark.version}")


get_ipython().system('wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-10.parquet')


df=spark.read.parquet('yellow_tripdata_2024-10.parquet')


df.show(5)


df.printSchema()


df \
    .repartition(4) \
    .write.parquet("data/yellow/")


df= df \
    .withColumnRenamed('tpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('tpep_dropoff_datetime', 'dropoff_datetime')


df.registerTempTable('yellow_trips_data')


spark.sql("""
SELECT
    count(1)
FROM
    yellow_trips_data
where extract(day from pickup_datetime)=15

""").show()


spark.sql("""
SELECT
    (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime)) / 3600.0 as trip_duration
FROM
    yellow_trips_data
order by 1 desc
limit 1
""").show()


spark.sql("""
SELECT
    (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime)) / 3600.0 as trip_duration
FROM
    yellow_trips_data
order by 1 desc
limit 1
""").show()


get_ipython().system('wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv')


df_zones=spark.read \
    .option("header", "true") \
    .csv('taxi_zone_lookup.csv')


df_zones.show(5)


df_zones.registerTempTable('taxi_zones')


spark.sql("""
SELECT
    zone, count(*)
FROM
    yellow_trips_data
inner join taxi_zones on PULocationID=LocationID
group by zone
order by 2
limit 1
""").show()
