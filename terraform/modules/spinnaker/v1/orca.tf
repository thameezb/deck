resource "kubernetes_deployment" "orca" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-orca"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "orca"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-orca"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"orca\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-orca"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "orca"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-orca"

          "shutdown.sh" = substr(sha256(kubernetes_config_map.orca.data["shutdown.sh"]), 0, 16)
        }, module.config["spin-orca"].labels)
        annotations = {

        }
      }

      spec {
        automount_service_account_token  = false
        enable_service_links             = false
        termination_grace_period_seconds = 60
        container {
          args    = []
          command = []

          image                      = local.orca_image
          image_pull_policy          = "IfNotPresent"
          name                       = "orca"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 8083
            protocol       = "TCP"
          }
          # port {
          #   name           = "debug"
          #   container_port = 7102
          #   protocol       = "TCP"
          # }

          env {
            name = "JAVA_OPTS"
            value = join(" ", [
              "-XX:MaxRAMPercentage=50.0",
              #   "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=7102",
              # "-Djava.net.preferIPv6Addresses=true",
              # "-Dspring.config.additional-location=/opt/spinnaker/config/,/opt/spinnaker/config-extra/,/secrets/configs/"
            ])
          }
          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "local"
          }

          lifecycle {
            pre_stop {
              exec {
                command = [
                  "bash",
                  "/opt/spinnaker/scripts/shutdown.sh",
                ]
              }
            }
          }

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
                "http://localhost:8083/health",
              ]
            }
          }
          volume_mount {
            mount_path = "/opt/spinnaker/config"
            name       = "spin-config"
            read_only  = false
          }
          volume_mount {
            name       = "scripts"
            mount_path = "/opt/spinnaker/scripts"
            read_only  = false
          }
        }



        volume {
          name = "spin-config"
          config_map {
            default_mode = "0644"
            name         = module.config["spin-orca"].name
          }
        }
        volume {
          name = "scripts"
          config_map {
            name = kubernetes_config_map.orca.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "orca" {
  metadata {
    name        = "spin-orca"
    namespace   = local.namespace
    annotations = {}
    labels = {
      app     = "spin"
      cluster = "spin-orca"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 8083
      target_port = 8083
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.orca.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.orca.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
