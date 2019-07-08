terraform {
  backend "gcs" {
    bucket = "storage-bucket-atsip76-stage"
    prefix = "stage"
  }
}
