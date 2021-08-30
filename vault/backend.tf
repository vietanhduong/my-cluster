terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "vault"
    region = "ap-southeast-1"
  }
}