
resource "helm_release" "efs_csi_driver" {
  name             = "aws-efs-csi-driver"
  chart            = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  version          = "2.2.0"
  namespace        = local.namespace
  create_namespace = true

  values = [file("${path.module}/values.yaml")]
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "${local.name}-sc"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    directoryPerms = "700"
    provisioningMode = "efs-ap"
    fileSystemId = local.fs_id
  }
}