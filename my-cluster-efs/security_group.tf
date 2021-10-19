data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_security_group" "this" {
  name   = "${var.name}_efs"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
}