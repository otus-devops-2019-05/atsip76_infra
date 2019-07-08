provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["storage-bucket-atsip76-stage", "storage-bucket-atsip76-prod"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
