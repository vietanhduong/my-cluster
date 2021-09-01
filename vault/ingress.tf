data "kubectl_file_documents" "ingress" {
  content = templatefile("${path.module}/ingress.yaml", {
    domain       = var.domain,
    service_name = "vault",
    port         = 8200 
  })
}

resource "kubectl_manifest" "ingress" {
  count      = length(data.kubectl_file_documents.ingress.documents)
  yaml_body  = element(data.kubectl_file_documents.ingress.documents, count.index)
  depends_on = [helm_release.vault]
}

