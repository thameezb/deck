output "config_map" {
  description = "The data of `kube-system/aws-auth` ConfigMap."
  value       = kubernetes_config_map_v1_data.aws_auth.data
}
