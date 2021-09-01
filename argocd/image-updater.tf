resource "helm_release" "image_updater" {
  count      = var.enabled_image_updater ? 1 : 0
  name       = "image-updater"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"

  cleanup_on_fail = true
  force_update    = true

  depends_on = [helm_release.argo]
}

data "kubectl_file_documents" "image_updater_cm" {
  content = file("${path.module}/image-updater-cm.yaml")
}

resource "kubectl_manifest" "image_updater_cm" {
  count           = var.enabled_image_updater ? length(data.kubectl_file_documents.image_updater_cm.documents) : 0
  yaml_body       = element(data.kubectl_file_documents.image_updater_cm.documents, count.index)
  validate_schema = false
  depends_on      = [helm_release.image_updater]
}

