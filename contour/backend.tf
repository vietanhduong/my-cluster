terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "contour"
    region = "ap-southeast-1"
  }
}