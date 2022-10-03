resource "kubernetes_deployment" "clouddriver" {
  # depends_on = [local_file.rendered_configs]
  metadata {
    name      = "spin-clouddriver"
    namespace = local.namespace
    labels = {
      "app"                          = "spin"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "clouddriver"
      "app.kubernetes.io/part-of"    = "spinnaker"
      "app.kubernetes.io/version"    = "1.28.1"
      "cluster"                      = "spin-clouddriver"
    }
    annotations = {
      "moniker.spinnaker.io/application" = "\"spin\""
      "moniker.spinnaker.io/cluster"     = "\"clouddriver\""
    }
  }
  spec {
    replicas                  = 1
    progress_deadline_seconds = 600
    revision_history_limit    = 10

    selector {
      match_labels = {
        app     = "spin"
        cluster = "spin-clouddriver"
      }
    }
    template {
      metadata {
        labels = merge({
          "app"                          = "spin"
          "app.kubernetes.io/managed-by" = "terraform"
          "app.kubernetes.io/name"       = "clouddriver"
          "app.kubernetes.io/part-of"    = "spinnaker"
          "app.kubernetes.io/version"    = "1.28.1"
          "cluster"                      = "spin-clouddriver"

          "kubeconfig_conf" = substr(sha256(kubernetes_config_map.kubeconfig.data["kubeconfig.conf"]), 0, 16)
        }, module.config["spin-clouddriver"].labels)
        annotations = {

        }
      }

      spec {
        service_account_name             = kubernetes_service_account.this.metadata[0].name
        automount_service_account_token  = true
        enable_service_links             = false
        termination_grace_period_seconds = 720
        container {
          args    = []
          command = []

          image                      = local.clouddriver_image
          image_pull_policy          = "IfNotPresent"
          name                       = "clouddriver"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          port {
            container_port = 7002
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

          env {
            name = "KEY_STORE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "saml-jks"
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
                "http://localhost:7002/health",
              ]
            }
          }
          volume_mount {
            mount_path = "/opt/spinnaker/config"
            name       = "spin-config"
            read_only  = false
          }
          volume_mount {
            name       = "kubeconfig"
            mount_path = "/spinnaker/k8s/"
            read_only  = false
          }
        }



        volume {
          name = "spin-config"
          config_map {
            default_mode = "0644"
            name         = module.config["spin-clouddriver"].name
          }
        }
        volume {
          name = "kubeconfig"
          config_map {
            name = kubernetes_config_map.kubeconfig.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "clouddriver" {
  metadata {
    name        = "spin-clouddriver"
    namespace   = local.namespace
    annotations = {}
    labels = {
      app     = "spin"
      cluster = "spin-clouddriver"
    }
  }
  spec {
    type = "ClusterIP"

    ip_family_policy = "SingleStack"
    ip_families      = ["IPv6"]

    port {
      # name        = "http"
      port        = 7002
      target_port = 7002
      protocol    = "TCP"
    }
    selector = {
      app     = kubernetes_deployment.clouddriver.spec[0].selector[0].match_labels.app
      cluster = kubernetes_deployment.clouddriver.spec[0].selector[0].match_labels.cluster
    }
  }
  wait_for_load_balancer = true
}
