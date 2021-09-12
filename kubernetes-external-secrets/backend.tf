terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "kubernetes-external-secrets"
    region = "ap-southeast-1"
  }
}