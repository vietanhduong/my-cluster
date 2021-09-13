data "kubectl_file_documents" "image-updater" {
  content = file("${path.module}/image-updater-v0.10.1.yaml")
}

resource "kubectl_manifest" "image-updater" {
  count              = var.enabled_image_updater ? length(data.kubectl_file_documents.image-updater.documents) : 0
  yaml_body          = element(data.kubectl_file_documents.image-updater.documents, count.index)
  override_namespace = kubernetes_namespace.argocd.metadata.0.name
  validate_schema    = false
}

