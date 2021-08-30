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

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"

  values = [file("values.yaml")]
}

resource "time_sleep" "wait_for_ssl_certs" {
  triggers = {
    helm_values = jsonencode(helm_release.cert_manager.values)
  }
  depends_on      = [helm_release.cert_manager]
  create_duration = "30s"
}

data "kubectl_file_documents" "issuer" {
  content = file("issuer.yaml")
}

resource "kubectl_manifest" "issuer" {
  count           = length(data.kubectl_file_documents.issuer.documents)
  yaml_body       = element(data.kubectl_file_documents.issuer.documents, count.index)
  depends_on      = [time_sleep.wait_for_ssl_certs]
  validate_schema = false
}

resource "kubernetes_secret" "cloudflare_api_key" {
  metadata {
    name      = "cloudflare-api-key"
    namespace = "cert-manager"
  }

  data = {
    api-key = var.cloudflare_api_key
  }

  depends_on = [helm_release.cert_manager]
}