from google.cloud import bigquery

# Initialize client
client = bigquery.Client()

# Dataset and table info
dataset_id = "trips_data_all"  # This should be your dataset name, not project ID
table_id = "yellow_tripdata_2024_01-06"
gcs_uri = "gs://joye-dezoomcamp_hw3_2025/*.parquet"

# First, create the dataset if it doesn't exist
try:
    client.get_dataset(dataset_id)  # Check if dataset exists
    print(f"Dataset {dataset_id} already exists")
except Exception as e:
    print(f"Dataset {dataset_id} not found, creating it...")
    dataset = bigquery.Dataset(f"{client.project}.{dataset_id}")
    dataset.location = "US"  # Set your preferred location
    client.create_dataset(dataset)
    print(f"Created dataset {dataset_id}")

# Configure and run the load job
job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.PARQUET
)

load_job = client.load_table_from_uri(
    gcs_uri,
    f"{client.project}.{dataset_id}.{table_id}",
    job_config=job_config
)

load_job.result()  # Waits for job to finish

print("Loaded {} rows into {}.{}".format(
    client.get_table(f"{dataset_id}.{table_id}").num_rows,
    dataset_id,
    table_id
))
