### 1. Using bq command-line tool to change a table namein BigQuery in local machine
```bsah
#gcloud components update

gcloud auth application-default login
```
chi-crime-project.kestra_crime_dataset.chi_crime_data_all
```bash
bq cp chi-crime-project:kestra_crime_dataset.chi_crime_data_all chi-crime-project:kestra_crime_dataset.chi_crime_data_partitioned_clustered

bq rm -t chi-crime-project:kestra_crime_dataset.chi_crime_data_all
```
--------------------------------------
##### Option 2: Using SQL (CREATE TABLE + DROP TABLE)
- Create a new table with the desired name
```sql
CREATE TABLE `your-project.your_dataset.new_table_name` AS
SELECT * FROM `your-project.your_dataset.old_table_name`;
```
- Verify the data
```sql
SELECT COUNT(*) FROM `your-project.your_dataset.new_table_name`;
```
- Drop the old table (be careful!)
```sql
DROP TABLE `your-project.your_dataset.old_table_name`;
```
--------------------------------------

### 2. Merge Staging tables into a new main table
```sql
CREATE OR REPLACE TABLE `chi-crime-project.kestra_crime_dataset.chi_crime_data_all` AS
SELECT * FROM (
  SELECT * FROM `chi-crime-project.kestra_crime_dataset.chi_crime_2021`
  UNION ALL
  SELECT * FROM `chi-crime-project.kestra_crime_dataset.chi_crime_2022`
  UNION ALL
  SELECT * FROM `chi-crime-project.kestra_crime_dataset.chi_crime_2023`
  UNION ALL
  SELECT * FROM `chi-crime-project.kestra_crime_dataset.chi_crime_2024`
  UNION ALL
  SELECT * FROM `chi-crime-project.kestra_crime_dataset.chi_crime_2025`
)
-- Optional: Deduplicate if needed
QUALIFY ROW_NUMBER() OVER (PARTITION BY unique_row_id ORDER BY Updated_On DESC) = 1
```
