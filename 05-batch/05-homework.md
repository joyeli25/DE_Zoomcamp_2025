# Module 5 Homework

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the Yellow 2024-10 data from the official website: 

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-10.parquet
```


## Question 1: Install Spark and PySpark

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

```python
import pyspark
from pyspark.sql import SparkSession
```
```python
# Create a local Spark session
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

# Execute spark.version
print(f"Spark version: {spark.version}")
```

What's the output?
>Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
25/08/21 05:34:29 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable

>Spark version: 3.3.2

> [!NOTE]
> To install PySpark follow this [guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/pyspark.md)


## Question 2: Yellow October 2024

Read the October 2024 Yellow into a Spark Dataframe.

Repartition the Dataframe to 4 partitions and save it to parquet.

```bash
ls -lh data/yellow/
```
>total 97M
-rw-r--r-- 1 joye joye   0 Aug 21 08:16 _SUCCESS
-rw-r--r-- 1 joye joye 25M Aug 21 08:16 part-00000-4b526bfd-d542-445a-83ba-727d9e887ca0-c000.snappy.parquet
-rw-r--r-- 1 joye joye 25M Aug 21 08:16 part-00001-4b526bfd-d542-445a-83ba-727d9e887ca0-c000.snappy.parquet
-rw-r--r-- 1 joye joye 25M Aug 21 08:16 part-00002-4b526bfd-d542-445a-83ba-727d9e887ca0-c000.snappy.parquet
-rw-r--r-- 1 joye joye 25M Aug 21 08:16 part-00003-4b526bfd-d542-445a-83ba-727d9e887ca0-c000.snappy.parquet

What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.

- ~~6MB~~
- 25MB
- ~~75MB~~
- ~~100MB~~


## Question 3: Count records 

How many taxi trips were there on the 15th of October?

```sql
spark.sql("""
SELECT
    count(1)
FROM
    yellow_trips_data
where extract(day from pickup_datetime)=15
""").show()
```
>+--------+
|count(1)|
+--------+
|  128893|
+--------+

Consider only trips that started on the 15th of October.

- ~~85,567~~
- ~~105,567~~
- 125,567
- ~~145,567~~


## Question 4: Longest trip

```sql
spark.sql("""
SELECT
    (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime)) / 3600.0 as trip_duration
FROM
    yellow_trips_data
order by 1 desc
limit 1
""").show()
```
>[Stage 27:=============================================>          (13 + 3) / 16]
+-------------+
|trip_duration|
+-------------+
|   162.617778|
+-------------+

What is the length of the longest trip in the dataset in hours?

- ~~122~~
- ~~142~~
- 162
- ~~182~~


## Question 5: User Interface

>http://localhost:4040/jobs/

Spark’s User Interface which shows the application's dashboard runs on which local port?

- ~~80~~
- ~~443~~
- 4040
- ~~8080~~



## Question 6: Least frequent pickup location zone

Load the zone lookup data into a temp view in Spark:

```bash
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```

Using the zone lookup data and the Yellow October 2024 data, what is the name of the LEAST frequent pickup location Zone?

```python
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
```
>+--------------------+--------+
|                zone|count(1)|
+--------------------+--------+
|Governor's Island...|       1|
+--------------------+--------+

- Governor's Island/Ellis Island/Liberty Island
- ~~Arden Heights~~
- ~~Rikers Island~~
- ~~Jamaica Bay~~


## Submitting the solutions

- Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw5
- Deadline: See the website
