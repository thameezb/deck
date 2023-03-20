resource "kubernetes_deployment" "igor" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-igor"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "igor"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-igor"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"igor\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-igor"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "igor"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-igor"
        }, module.config["spin-igor"].labels)
        annotations = {}
      }

      spec {
        automount_service_account_token  = false
        enable_service_links             = false
        termination_grace_period_seconds = 60
        container {
          args    = []
          command = []

          image                      = local.igor_image
          image_pull_policy          = "IfNotPresent"
          name                       = "igor"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 8088
            protocol       = "TCP"
          }

          env {
            name = "JAVA_OPTS"
            value = join(" ", [
              "-XX:MaxRAMPercentage=50.0",
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
                "http://localhost:8088/health",
              ]
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
            name         = module.config["spin-igor"].name
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

resource "kubernetes_service" "igor" {
  metadata {
    name      = "spin-igor"
    namespace = local.namespace
    annotations = {

    }
    labels = {
      app     = "spin"
      cluster = "spin-igor"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 8088
      target_port = 8088
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.igor.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.igor.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
