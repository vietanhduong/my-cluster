data "kubectl_file_documents" "cert" {
  content = templatefile("${path.module}/cert.yaml", {
    domain = var.domain
  })
}

resource "kubectl_manifest" "cert" {
  count      = length(data.kubectl_file_documents.cert.documents)
  yaml_body  = element(data.kubectl_file_documents.cert.documents, count.index)
  depends_on = [helm_release.vault]
}

