terraform {
  backend "gcs" {
    bucket = "remote-backend"
    prefix = "prod"
  }
}
