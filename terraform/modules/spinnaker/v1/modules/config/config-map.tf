resource "kubernetes_config_map" "this" {
  metadata {
    name      = "${var.service}-files"
    namespace = var.namespace
    labels = merge({
      app     = var.app
      cluster = var.service
    }, local.labels)
  }
  data = zipmap(local.files, [for f in local_file.this : f.content])
}

locals {
  files  = toset(var.config_files)
  labels = zipmap(local.files, [for f in local_file.this : substr(sha256(f.content), 0, 16)])
}

resource "local_file" "this" {
  for_each        = local.files
  content         = templatefile("${path.module}/config/${each.key}", var.params)
  filename        = "generated/${var.service}/${each.key}"
  file_permission = 0644
}
