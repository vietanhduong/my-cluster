terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "my-cluster-efs"
    region = "ap-southeast-1"
  }
}