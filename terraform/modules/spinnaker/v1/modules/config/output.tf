output "labels" {
  value = local.labels
}

output "name" {
  value = kubernetes_config_map.this.metadata[0].name
}
