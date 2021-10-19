locals {
  namespace    = "amazon-cloudwatch"
  cluster_name = data.terraform_remote_state.eks.outputs.cluster_id
  region       = data.terraform_remote_state.eks.outputs.region
}