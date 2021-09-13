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


resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    annotations = {
      name = "argocd"
    }
    labels = {
      name = "argocd"
      # Uncomment if you want to inject istio sidecar
      # istio-injection = "enabled"
    }
  }
}

resource "helm_release" "argo" {
  name       = "argo"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  version = "3.6.0"

  cleanup_on_fail = true
  force_update    = true

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.argocd]
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
  content = templatefile("${path.module}/certificate.yaml", {
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
  content = templatefile("${path.module}/argocd-cm.yml", {
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
  content = file("${path.module}/rbac.yml")
}

resource "kubectl_manifest" "rbac" {
  count           = length(data.kubectl_file_documents.rbac.documents)
  yaml_body       = element(data.kubectl_file_documents.rbac.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
}

