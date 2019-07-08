terraform {
  backend "gcs" {
    bucket = "storage-bucket-atsip76-prod"
    prefix = "prod"
  }
}
