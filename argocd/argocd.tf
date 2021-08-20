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
  }

  depends_on = [helm_release.argo]
}

## ORDER CERTIFICATE
data "kubectl_file_documents" "argocd_cert" {
  content = templatefile("certificate.yaml", {
    domain = var.domain
  })
}

resource "kubectl_manifest" "argocd_cert" {
  count           = length(data.kubectl_file_documents.argocd_cert.documents)
  yaml_body       = element(data.kubectl_file_documents.argocd_cert.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
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

# PATCH RBAC
data "kubectl_file_documents" "rbac" {
  content = file("rbac.yml")
}

resource "kubectl_manifest" "rbac" {
  count           = length(data.kubectl_file_documents.rbac.documents)
  yaml_body       = element(data.kubectl_file_documents.rbac.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
}

