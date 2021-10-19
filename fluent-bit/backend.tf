terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "fluent-bit"
    region = "ap-southeast-1"
  }
}