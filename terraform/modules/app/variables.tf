variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable name {
  description = "Name instance"
  default     = "reddit-app"
}

variable db_external_ip {
  default = "127.0.0.1"
}
