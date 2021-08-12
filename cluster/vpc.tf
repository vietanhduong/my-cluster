data "aws_availability_zones" "available" {}

resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = "${local.cluster_name}-nat-eip"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name                   = "${local.cluster_name}-vpc"
  cidr                   = var.cidr_range
  azs                    = length(var.availability_zones) == 0 ? data.aws_availability_zones.available.names : var.availability_zones
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true
  external_nat_ip_ids    = [aws_eip.nat_ip.id]


  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    Owner                                         = local.owner
    user_id_creator                               = data.aws_caller_identity.current.arn
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

}
