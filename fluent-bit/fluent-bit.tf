resource "kubernetes_namespace" "this" {
  metadata {
    labels = {
      name = local.namespace
    }

    name = local.namespace
  }
}

resource "kubernetes_config_map" "this" {
  metadata {
    name      = "fluent-bit-cluster-info"
    namespace = local.namespace
  }

  data = {
    "cluster.name" = local.cluster_name
    "logs.region"  = local.region
    "http.server"  = var.fluent_bit_http_server
    "http.port"    = var.fluent_bit_http_port
    "read.head"    = var.fluent_bit_read_from_head
    "read.tail"    = var.fluent_bit_read_from_head == "On" ? "Off" : "On"
  }

  depends_on = [kubernetes_namespace.this]
}

data "kubectl_file_documents" "fluent_bit" {
  content = file("${path.module}/fluent-bit-2.10.0.yaml")
}

resource "kubectl_manifest" "fluent_bit" {
  count              = length(data.kubectl_file_documents.fluent_bit.documents)
  yaml_body          = element(data.kubectl_file_documents.fluent_bit.documents, count.index)
  override_namespace = local.namespace
  validate_schema    = false

  depends_on = [kubernetes_config_map.this]
}