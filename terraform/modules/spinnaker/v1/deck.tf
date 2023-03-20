resource "kubernetes_deployment" "deck" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-deck"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "deck"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-deck"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"deck\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-deck"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "deck"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-deck"
        }, module.config["spin-deck"].labels)
        annotations = {}
      }

      spec {
        automount_service_account_token  = false
        enable_service_links             = false
        termination_grace_period_seconds = 60
        container {
          args    = []
          command = []

          image                      = local.deck_image
          image_pull_policy          = "IfNotPresent"
          name                       = "deck"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 9000
            protocol       = "TCP"
          }

          env {
            name  = "DECK_HOST"
            value = "[::]"
          }

          env {
            name  = "API_HOST"
            value = "http://spin-gate:8084"
          }

          lifecycle {}

          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 0
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1

            tcp_socket {
              port = 9000
            }
          }
          volume_mount {
            mount_path = "/opt/spinnaker/config"
            name       = "spin-config"
            read_only  = false
          }
          volume_mount {
            name       = "empty-dir"
            mount_path = "/opt/spinnaker/plugins"
          }
        }


        volume {
          name = "spin-config"
          config_map {
            default_mode = "0644"
            name         = module.config["spin-deck"].name
          }
        }
        volume {
          name = "empty-dir"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "deck" {
  metadata {
    name      = "spin-deck"
    namespace = local.namespace
    annotations = {

    }
    labels = {
      app     = "spin"
      cluster = "spin-deck"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 9000
      target_port = 9000
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.deck.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.deck.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
