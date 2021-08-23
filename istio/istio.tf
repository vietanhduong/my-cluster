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

resource "helm_release" "istio-base" {
  name             = "istio-base"
  namespace        = "istio-system"
  create_namespace = true
  chart            = ".charts/base"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true
}

resource "helm_release" "istiod" {
  name             = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  chart            = ".charts/istio-control/istio-discovery"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  depends_on = [helm_release.istio-base]
}

resource "helm_release" "istio-ingress" {
  name             = "istio-ingress"
  namespace        = "istio-system"
  create_namespace = true
  chart            = ".charts/gateways/istio-ingress"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  values = [file("values/gateways/ingress.yaml")]

  depends_on = [helm_release.istiod]
}

resource "helm_release" "istio-egress" {
  name             = "istio-egress"
  namespace        = "istio-system"
  create_namespace = true
  chart            = ".charts/gateways/istio-egress"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = true

  depends_on = [helm_release.istiod]
}