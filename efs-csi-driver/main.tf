
resource "helm_release" "efs_csi_driver" {
  name             = "aws-efs-csi-driver"
  chart            = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  version          = "2.2.0"
  namespace        = local.namespace
  create_namespace = true

  values = [file("${path.module}/values.yaml")]
}

resource "kubectl_manifest" "storage_class" {
  yaml_body = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ${local.name}-sc
provisioner: efs.csi.aws.com
parameters:
  directoryPerms: "700"
  provisioningMode: efs-ap
  fileSystemId: ${local.fs_id}
YAML
}