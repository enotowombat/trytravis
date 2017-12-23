variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable provider_version {
  description = "Google provider version"
}

variable zone {
  description = "Compute instance zone"
  default     = "europe-west1-b"
}
