## Module 2 Homework

ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format, please include these directly in the README file of your repository.

> In case you don't get one option exactly, select the closest one 

For the homework, we'll be working with the _green_ taxi dataset located here:

`https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/green/download`

To get a `wget`-able link, use this prefix (note that the link itself gives 404):

`https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/`

### Assignment

So far in the course, we processed data for the year 2019 and 2020. Your task is to extend the existing flows to include data for the year 2021.

![homework datasets](../../../02-workflow-orchestration/images/homework.png)

As a hint, Kestra makes that process really easy:
1. You can leverage the backfill functionality in the [scheduled flow](../../../02-workflow-orchestration/flows/06_gcp_taxi_scheduled.yaml) to backfill the data for the year 2021. Just make sure to select the time period for which data exists i.e. from `2021-01-01` to `2021-07-31`. Also, make sure to do the same for both `yellow` and `green` taxi data (select the right service in the `taxi` input).
2. Alternatively, run the flow manually for each of the seven months of 2021 for both `yellow` and `green` taxi data. Challenge for you: find out how to loop over the combination of Year-Month and `taxi`-type using `ForEach` task which triggers the flow for each combination using a `Subflow` task.

### Quiz Questions

Complete the Quiz shown below. It’s a set of 6 multiple-choice questions to test your understanding of workflow orchestration, Kestra and ETL pipelines for data lakes and warehouses.

1) Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?

#### Answer:
- 128.3 MiB ( I actually never see there is file size in the output page)


2) What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?

>kestra:///zoomcamp/02-postgres-taxi-scheduled/executions/3OidVtZnkLH3CMHQxnUIwT/tasks/extract/1SNAiLyLY5OXJ46FJylAZt/4Oeogijrw1TyhR2m0Qi8AT-green_tripdata_2020-04.csv
#### Answer:
- `green_tripdata_2020-04.csv`


3) How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
```sql
SELECT count(*) FROM public.yellow_tripdata
where left(filename,20)='yellow_tripdata_2020'
```
>"count"
24648499

#### Answer:
- 24,648,499


4) How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
```sql
SELECT count(*) FROM public.green_tripdata
where left(filename,19)='green_tripdata_2020'
```
>"count"
1734051

#### Answer:
- 1,734,051


5) How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
```sql
SELECT count(*) FROM public.yellow_tripdata
where left(filename,23)='yellow_tripdata_2021-03'
```
>"count"
1925152
>
#### Answer:
- 1,925,152


6) How would you configure the timezone to New York in a Schedule trigger?
>By default, Kestra uses UTC. To schedule flows according to New York time, include the timezone property with the IANA timezone identifier America/New_York. In our case, this would be the updates in 02_postgres_taxi_scheduled.yaml file:
```yaml
triggers:
  - id: green_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 9 1 * *"
    timezone: America/New_York
    inputs:
      taxi: green

  - id: yellow_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 10 1 * *"
    timezone: America/New_York
    inputs:
      taxi: yellow
```
#### Answer:
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
 


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw2
* Check the link above to see the due date

## Solution

Will be added after the due date
