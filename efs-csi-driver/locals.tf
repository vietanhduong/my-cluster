locals {
  eks_output           = data.terraform_remote_state.eks.outputs
  name                 = "my-cluster"
  namespace            = "kube-system"
  service_account_name = "efs-csi-controller-sa"
  fs_id                = data.terraform_remote_state.my_cluster_efs.outputs.fs_id
}