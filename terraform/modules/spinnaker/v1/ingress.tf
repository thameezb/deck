# https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md
resource "kubernetes_ingress_v1" "this" {
  metadata {
    name      = "load-balancer"
    namespace = "spinnaker"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "spinnaker.double.tech, gate.spinnaker.double.tech"
      "alb.ingress.kubernetes.io/ip-address-type" = "dualstack"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/certificate-arn" = var.acm_arn
      "alb.ingress.kubernetes.io/group.name"      = "spinnaker-prod"
      "alb.ingress.kubernetes.io/ssl-redirect"    = "443"
      "alb.ingress.kubernetes.io/listen-ports"    = jsonencode([{ HTTP = 80 }, { HTTPS = 443 }])
    }
  }
  wait_for_load_balancer = true
  spec {
    ingress_class_name = "alb"
    # rule {
    #   host = "gate.spinnaker.double.tech"
    #   http {
    #     path {
    #       path_type = "Prefix"
    #       path      = "/"
    #       backend {
    #         service {
    #           name = "spin-gate"
    #           port {
    #             number = 8084
    #           }
    #         }
    #       }
    #     }
    #   }
    # }
    rule {
      host = "spinnaker.double.tech"
      http {
        path {
          path_type = "Prefix"
          path      = "/auth"
          backend {
            service {
              name = "spin-gate"
              port {
                number = 8084
              }
            }
          }
        }
        path {
          path_type = "Prefix"
          path      = "/"
          backend {
            service {
              name = "spin-deck"
              port {
                number = 9000
              }
            }
          }
        }
      }
    }
  }
}
