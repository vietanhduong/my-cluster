data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

resource "helm_release" "vault" {
  name             = "vault"
  namespace        = "vault"
  create_namespace = true
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"

  values = [templatefile("values.yml", {
    region        = local.region
    vault_storage = aws_s3_bucket.vault.id,
    vault_key     = aws_kms_key.vault.key_id
  })]
}

data "kubernetes_service" "vault" {
  metadata {
    name      = "vault"
    namespace = "vault"
  }

  depends_on = [helm_release.vault]
}
