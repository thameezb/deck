resource "kubernetes_deployment" "gate" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-gate"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "gate"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-gate"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"gate\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-gate"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "gate"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-gate"
        }, module.config["spin-gate"].labels)
        annotations = {}
      }

      spec {
        automount_service_account_token  = false
        enable_service_links             = false
        termination_grace_period_seconds = 60
        container {
          args    = []
          command = []

          image                      = local.gate_image
          image_pull_policy          = "IfNotPresent"
          name                       = "gate"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 8084
            protocol       = "TCP"
          }

          env {
            name = "JAVA_OPTS"
            value = join(" ", [
              "-XX:MaxRAMPercentage=50.0",
              # "-Djava.net.preferIPv6Addresses=true",
              # "-Dspring.config.additional-location=/opt/spinnaker/config/,/opt/spinnaker/config-extra/,/secrets/configs/"
            ])
          }
          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "local"
          }

          env {
            name = "KEY_STORE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "saml"
                key  = "password"
              }
            }
          }

          lifecycle {}

          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 0
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1

            exec {
              command = [
                "wget",
                "--no-check-certificate",
                "--spider",
                "-q",
                "http://localhost:8084/health",
              ]
            }
          }
          volume_mount {
            mount_path = "/opt/spinnaker/config"
            name       = "spin-config"
            read_only  = false
          }
          volume_mount {
            mount_path = "/opt/spinnaker/secrets"
            name       = "saml-jks"
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
            name         = module.config["spin-gate"].name
          }
        }
        volume {
          name = "saml-jks"
          secret {
            default_mode = "0644"
            secret_name  = "saml"
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

resource "kubernetes_service" "gate" {
  metadata {
    name      = "spin-gate"
    namespace = local.namespace
    annotations = {

    }
    labels = {
      app     = "spin"
      cluster = "spin-gate"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 8084
      target_port = 8084
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.gate.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.gate.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
