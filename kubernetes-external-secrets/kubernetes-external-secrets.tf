data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "my-cluster-backend"
    key    = "cluster"
    region = "ap-southeast-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

resource "helm_release" "kubernetes-external-secrets" {
  name             = "kubernetes-external-secrets"
  namespace        = "kubernetes-external-secrets"
  create_namespace = true
  repository       = "https://external-secrets.github.io/kubernetes-external-secrets"
  chart            = "kubernetes-external-secrets"

  values = [file("${path.module}/values.yaml")]
}
