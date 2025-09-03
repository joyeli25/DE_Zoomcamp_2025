variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-key.json"
}

variable "project" {
  description = "My Project Name"
  default     = "ProjectName"
}

variable "region" {
  description = "Region Name"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "DatasetName_tobecreated"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "BucketName_tobecreated"
}

variable "gcs_dataset_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
