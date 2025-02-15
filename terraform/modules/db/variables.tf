variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable name {
  description = "Name instance"
  default     = "reddit-db"
}

variable app_external_ip {
  default = "127.0.0.1"
}
