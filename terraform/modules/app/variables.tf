variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Compute instance zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
}

variable db_internal_ip {
  description = "Database IP address"
}
