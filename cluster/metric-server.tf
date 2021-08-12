resource "helm_release" "metric_server" {
  name            = "metrics-server"
  namespace       = "kube-system"
  repository      = "https://charts.helm.sh/stable"
  chart           = "metrics-server"
  cleanup_on_fail = true

  dynamic "set" {
    for_each = {
      "args[0]" = "--kubelet-preferred-address-types=InternalIP"
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [
    module.cluster
  ]
}
