resource "kubernetes_ingress" "argo" {

  wait_for_load_balancer = true
  metadata {
    name      = "argo-ingress"
    namespace = "argocd"
    annotations = {
      "cert-manager.io/acme-challenge-type"      = "http01"
      "cert-manager.io/cluster-issuer"           = "letsencrypt"
      "ingress.kubernetes.io/force-ssl-redirect" = "true"
      "kubernetes.io/ingress.class"              = "contour"
    }
  }

  spec {
    tls {
      hosts       = [var.domain]
      secret_name = "tls.${var.domain}"
    }
    rule {
      host = var.domain
      http {
        path {
          path = "/"
          backend {
            service_name = data.kubernetes_service.argo.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}
