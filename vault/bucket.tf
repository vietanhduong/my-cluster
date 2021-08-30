resource "aws_s3_bucket" "vault" {
  bucket = "${local.cluster_name}-vault"
  acl    = "private"
  versioning {
    enabled = false
  }
}
