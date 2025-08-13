# Module 1 Homework: Docker & SQL

Solution: [solution.md](solution.md)

In this homework we'll prepare the environment and practice
Docker and SQL

When submitting your homework, you will also need to include
a link to your GitHub repository or other public code-hosting
site.

This repository should contain the code for solving the homework. 

When your solution has SQL or shell commands and not code
(e.g. python files) file format, include them directly in
the README file of your repository.


## Question 1. Understanding docker first run 

Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint `bash`.

What's the version of `pip` in the image?

```bash
docker run -it python:3.12.8 bash
```
>root@2defe6400ba5:/# pip --version
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)

###Answer:
- 24.3.1


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

```bash
docker-compose up -d
docker ps

docker exec -it pgadmin bash
da04ca5309f9:/pgadmin4$ nc -zv db 5432
db (172.21.0.2:5432) open
da04ca5309f9:/pgadmin4$ nc -zv postgres 5432
postgres (172.21.0.2:5432) open
```
>CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS         PORTS                                            NAMES
da04ca5309f9   dpage/pgadmin4:latest   "/entrypoint.sh"         15 seconds ago   Up 9 seconds   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp   pgadmin
05da863b7097   postgres:17-alpine      "docker-entrypoint.s…"   15 seconds ago   Up 9 seconds   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp        postgres

###Answer:
- postgres:5432
- db:5432

If there are more than one answers, select only one of them

##  Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from October 2019:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

You will also need the dataset with zones:

```bash
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

Download this data and put it into Postgres.

```bash
pgcli -h localhost -p 5433 -u postgres -d ny_taxi

docker build -t taxi_ingest:v001 .

url='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz'

docker run -it \
  --network=01-homework_default \
  taxi_ingest:v001 \
    --user=postgres \
    --password=postgres \
    --host=db \
    --port=5432 \
    --db=ny_taxi \
    --table_name=taxi_zones \
    --url=${url}

docker build -t taxi_ingest:v002 .

url='https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv'

docker run -it \
  --network=01-homework_default \
  taxi_ingest:v002 \
    --user=postgres \
    --password=postgres \
    --host=db \
    --port=5432 \
    --db=ny_taxi \
    --table_name=taxi_zones \
    --url=${url}
    ```

You can use the code from the course. It's up to you whether
you want to use Jupyter or a python script.

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 

```sql
select 
count(case when trip_distance<=1 then 1 end) as "up_to-1_mile",
count(case when trip_distance>1 and trip_distance<=3 then 1 end) as "1-3_mile",
count(case when trip_distance>3 and trip_distance<=7 then 1 end) as "3-7_mile",
count(case when trip_distance>7 and trip_distance<=10 then 1 end) as "7-10_mile",
count(case when trip_distance>10 then 1 end) as "above_10_mile"
from green_taxi_trips_2019_10
where lpep_pickup_datetime>='2019-10-01'
and lpep_pickup_datetime<'2019-11-01'
and lpep_dropoff_datetime>='2019-10-01'
and lpep_dropoff_datetime<'2019-11-01'
```
>"up_to-1_mile"	"1-3_mile"	"3-7_mile"	"7-10_mile"	"above_10_mile"
104802	198924	109603	27678	35189

###Answers:
- 104,802;  198,924;  109,603;  27,678;  35,189


## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance. 

```sql
select date(lpep_pickup_datetime), max(trip_distance)
from green_taxi_trips_2019_10
group by date(lpep_pickup_datetime)
order by 2 desc
limit 1
```
>"date"	"max"
"2019-10-31"	515.89

###Answer:
- 2019-10-31


## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.

```sql
select z."Zone", sum(total_amount)
from green_taxi_trips_2019_10 t
inner join taxi_zones z on t."PULocationID"=z."LocationID"
where date(t.lpep_pickup_datetime)='2019-10-18'
group by z."Zone"
order by 2 desc
limit 3
```
>"Zone"	"sum"
"East Harlem North"	18686.680000000088
"East Harlem South"	16797.26000000007
"Morningside Heights"	13029.79000000003

###Answer:
- East Harlem North, East Harlem South, Morningside Heights


## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
named "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.

```sql
select z2."Zone", max(tip_amount)
from green_taxi_trips_2019_10 t
inner join taxi_zones z1 on t."PULocationID"=z1."LocationID"
inner join taxi_zones z2 on t."DOLocationID"=z2."LocationID"
where lpep_pickup_datetime>='2019-10-01'
and lpep_pickup_datetime<'2019-11-01'
and z1."Zone"='East Harlem North'
group by z2."Zone"
order by 2 desc
limit 1
```
>"Zone"	"max"
"JFK Airport"	87.3

- JFK Airport


## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](../../../01-docker-terraform/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

```bash
cd ..
cp 1_terraform_gcp/terraform/terraform_with_variables/main.tf 01-homework/main.tf
cp 1_terraform_gcp/terraform/terraform_with_variables/variables.tf 01-homework/variables.tf

teeraform init
terraform plan
terraform apply
terraform destroy
```
>google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_storage_bucket.demo-bucket: Creation complete after 1s [id=copper-seeker-466202-f5-terra-bucket]
google_bigquery_dataset.demo_dataset: Creation complete after 1s [id=projects/copper-seeker-466202-f5/datasets/demo_dataset]
>google_storage_bucket.demo-bucket: Destroying... [id=copper-seeker-466202-f5-terra-bucket]
google_bigquery_dataset.demo_dataset: Destroying... [id=projects/copper-seeker-466202-f5/datasets/demo_dataset]
google_bigquery_dataset.demo_dataset: Destruction complete after 0s
google_storage_bucket.demo-bucket: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.

###Answers:
- terraform init, terraform apply -auto-approve, terraform destroy



## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw1
