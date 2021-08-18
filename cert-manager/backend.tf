terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "cert-manager"
    region = "ap-southeast-1"
  }
}