resource "aws_s3_bucket" "backend" {
  bucket = "my-cluster-backend"
  acl    = "private"

  tags = {
    Name = "My Cluster Backend"
  }

  versioning {
    enabled = true
  }
}