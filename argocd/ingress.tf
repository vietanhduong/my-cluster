data "kubectl_file_documents" "ingress" {
  content = templatefile("ingress.yaml", {
    domain       = var.domain,
    service_name = "argo-argocd-server"
  })
}

resource "kubectl_manifest" "ingress" {
  count           = length(data.kubectl_file_documents.ingress.documents)
  yaml_body       = element(data.kubectl_file_documents.ingress.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.argo]
}

