terraform {
  backend "s3" {
    bucket = "my-cluster-backend"
    key    = "efs-csi-driver"
    region = "ap-southeast-1"
  }
}