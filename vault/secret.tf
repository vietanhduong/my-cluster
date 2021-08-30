resource "kubernetes_secret" "vault_s3" {
  metadata {
    name      = "vault-s3"
    namespace = "vault"
  }
  data = {
    "aws_access_key" = var.robot_access_key
    "aws_secret_key" = var.robot_secret_key
  }

  depends_on = [helm_release.vault]
}
