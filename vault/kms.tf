resource "aws_kms_key" "vault" {
  description             = "${local.cluster_name} Vault unseal key"
  deletion_window_in_days = 10

  tags = {
    Name = "${local.cluster_name}-vault-kms-unseal"
  }
}
