resource "kubernetes_service_account" "csi_driver" {

  metadata {
    name      = local.service_account_name
    namespace = local.namespace
    annotations = {
      "eks.amazonaws.com/role-arn"   = aws_iam_role.this.arn
      "eks.amazonaws.com/policy-arn" = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
  }
  automount_service_account_token = true
}
