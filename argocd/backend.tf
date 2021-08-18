terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "argocd"
    region = "ap-southeast-1"
  }
}