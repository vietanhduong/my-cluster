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

resource "helm_release" "argo" {
  name             = "argo"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  values = [file("values.yaml")]
}

data "kubernetes_service" "argo" {
  metadata {
    name      = "argo-argocd-server"
    namespace = "argocd"
    annotations = {
      "contour.heptio.com/upstream-protocol.h2" = "https,443"
    }
  }

  depends_on = [helm_release.argo]
}

## PATCH CONFIG MAP
data "kubectl_file_documents" "argocd_cm" {
  content = templatefile("argocd-cm.yml", {
    domain = var.domain
  })
}

resource "kubectl_manifest" "argocd_cm" {
  count           = length(data.kubectl_file_documents.argocd_cm.documents)
  yaml_body       = element(data.kubectl_file_documents.argocd_cm.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
}

data "kubectl_file_documents" "rbac" {
  content = file("rbac.yml")
}

resource "kubectl_manifest" "rbac" {
  count           = length(data.kubectl_file_documents.rbac.documents)
  yaml_body       = element(data.kubectl_file_documents.rbac.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
}

## ARGOCD IMAGE UPDATER
data "kubectl_file_documents" "argo_image_updater" {
  content = file("argocd-image-updater-v0.10.2.yaml")
}

resource "kubectl_manifest" "argo_image_updater" {
  count              = length(data.kubectl_file_documents.argo_image_updater.documents)
  yaml_body          = element(data.kubectl_file_documents.argo_image_updater.documents, count.index)
  depends_on         = [helm_release.argo]
  override_namespace = "argocd"
  validate_schema    = false
}
