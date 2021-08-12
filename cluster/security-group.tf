resource "aws_security_group" "worker" {
  vpc_id      = module.vpc.vpc_id
  name_prefix = "worker"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
  tags = {
    "Name" = "${local.cluster_name}-worker"
  }
}
