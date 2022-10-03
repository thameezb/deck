resource "kubernetes_deployment" "rosco" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-rosco"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "rosco"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-rosco"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"rosco\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-rosco"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "rosco"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-rosco"

        }, module.config["spin-rosco"].labels)
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

          image                      = local.rosco_image
          image_pull_policy          = "IfNotPresent"
          name                       = "rosco"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 8087
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
                "http://localhost:8087/health",
              ]
            }
          }
          volume_mount {
            mount_path = "/opt/spinnaker/config"
            name       = "spin-config"
            read_only  = false
          }
          volume_mount {
            name       = "packer"
            mount_path = "/opt/rosco/config/packer"
            read_only  = false
          }
          volume_mount {
            name       = "scripts"
            mount_path = "/opt/rosco/config/packer/scripts"
            read_only  = false
          }
        }



        volume {
          name = "spin-config"
          config_map {
            default_mode = "0644"
            name         = module.config["spin-rosco"].name
          }
        }
        volume {
          name = "scripts"
          config_map {
            name = kubernetes_config_map.rosco-scripts.metadata[0].name
          }
        }
        volume {
          name = "packer"
          config_map {
            name = kubernetes_config_map.rosco-packer.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rosco" {
  metadata {
    name        = "spin-rosco"
    namespace   = local.namespace
    annotations = {}
    labels = {
      app     = "spin"
      cluster = "spin-rosco"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 8087
      target_port = 8087
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.rosco.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.rosco.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
