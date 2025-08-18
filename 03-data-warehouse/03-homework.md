## Module 3 Homework

ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. 
This repository should contain your code for solving the homework. If your solution includes code that is not in file format (such as SQL queries or 
shell commands), please include these directly in the README file of your repository.

<b><u>Important Note:</b></u> <p> For this homework we will be using the Yellow Taxi Trip Records for **January 2024 - June 2024 NOT the entire year of data** 
Parquet Files from the New York
City Taxi Data found here: </br> https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page </br>
If you are using orchestration such as Kestra, Mage, Airflow or Prefect etc. do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>

**Load Script:** You can manually download the parquet files and upload them to your GCS Bucket or you can use the linked script [here](./load_yellow_taxi_data.py):<br>
You will simply need to generate a Service Account with GCS Admin Priveleges or be authenticated with the Google SDK and update the bucket name in the script to the name of your bucket<br>
Nothing is fool proof so make sure that all 6 files show in your GCS Bucket before begining.</br><br>

<u>NOTE:</u> You will need to use the PARQUET option files when creating an External Table</br>

<b>BIG QUERY SETUP:</b></br>
Create an external table using the Yellow Taxi Trip Records. </br>
Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table). </br>
</p>

## Question 1:
Question 1: What is count of records for the 2024 Yellow Taxi Data?
```sql
SELECT count(*) FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`
```
>20332093

#### Answer:
- 20,332,093



## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?
```sql
CREATE OR REPLACE EXTERNAL TABLE `copper-seeker-466202-f5.trips_data_all.external_yellow_tripdata_2024_01-06`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://joye-dezoomcamp_hw3_2025/*.parquet']
);
SELECT count(distinct PULocationID) FROM `copper-seeker-466202-f5.trips_data_all.external_yellow_tripdata_2024_01-06`;
```
>Bytes processed
0 B (results cached)
Bytes billed
0 B

```sql
SELECT count(distinct PULocationID) FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`;
```
>Bytes processed
155.12 MB
Bytes billed
156 MB
Slot milliseconds
6186

#### Answer:
- 0 MB for the External Table and 155.12 MB for the Materialized Table

## Question 3:
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?
#### Answer:
- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires 
reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

## Question 4:
How many records have a fare_amount of 0?
```sql
SELECT count(*) FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`
where fare_amount=0 or fare_amount is null
```

#### Answer:
- 8,333

## Question 5:
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
```sql
CREATE OR REPLACE TABLE `copper-seeker-466202-f5.trips_data_all.optimized_yellow_tripdata_2024_01-06`
PARTITION BY DATE(tpep_dropoff_datetime)  -- Daily partitions
CLUSTER BY VendorID                      -- Sort within partitions
AS (
  SELECT * FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`
);
```

#### Answer:
- Partition by tpep_dropoff_datetime and Cluster on VendorID

## Question 6:
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 
```sql
SELECT count(distinct VendorID) FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';
```
>Bytes processed
310.24 MB
Bytes billed
311 MB
Slot milliseconds
5107

```sql
SELECT count(distinct VendorID) FROM `copper-seeker-466202-f5.trips_data_all.optimized_yellow_tripdata_2024_01-06`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';
```
>Bytes processed
26.84 MB
Bytes billed
27 MB
Slot milliseconds
2859

#### Answer:
- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table


## Question 7: 
Where is the data stored in the External Table you created?

#### Answer:
- GCP Bucket


## Question 8:
It is best practice in Big Query to always cluster your data:

#### Answer:
- False


## (Bonus: Not worth points) Question 9:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
```sql
SELECT count(*) FROM `copper-seeker-466202-f5.trips_data_all.yellow_tripdata_2024_01-06`;
```
#### Answer:
Bytes processed
0 B
Bytes billed
0 B
Slot milliseconds
2522

BigQuery stores row count statistics in its metadata. For COUNT(*):
It doesn’t scan the actual data.
It reads precomputed metadata (like total_rows in INFORMATION_SCHEMA).


## Submitting the solutions

Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw3

## Solution

Solution: https://www.youtube.com/watch?v=wpLmImIUlPg
