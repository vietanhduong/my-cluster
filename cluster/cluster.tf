
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name

  # should specify cluster version
  cluster_version = var.cluster_version

  subnets = module.vpc.private_subnets
  vpc_id  = module.vpc.vpc_id

  # use aws-cli to get cluster credentials
  write_kubeconfig = false

  # enables private access for bastion
  cluster_endpoint_private_access = true

  # restrict public IPs address can access to clusster
  cluster_endpoint_public_access_cidrs = var.allowed_cidrs

  workers_group_defaults = {
    root_volume_type = var.volume_type
    disk_size        = var.volume_size
    public_ip        = false
  }

  worker_groups = [
    {
      name                          = "worker_group"
      instance_type                 = var.worker_tier
      additional_security_group_ids = [aws_security_group.worker.id]
      arg_min_size                  = var.min_worker
      asg_max_size                  = var.max_worker

      # enable worker autoscaling
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    },
  ]
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

