terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "istio"
    region = "ap-southeast-1"
  }
}