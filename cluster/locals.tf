locals {
  cluster_name                       = var.cluster_name != "" ? var.cluster_name : "eks-${random_string.suffix.result}"
  cluster_autoscaler_service_account = "cluster-autoscaler"
  arn_splited                        = split("/", data.aws_caller_identity.current.arn)
  owner                              = length(local.arn_splited) > 0 ? local.arn_splited[1] : (var.default_owner != "" ? var.default_owner : "root")
}
