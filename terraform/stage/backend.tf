terraform {
  backend "gcs" {
    bucket = "remote-backend"
    prefix = "stage"
  }
}
