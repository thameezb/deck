module "config" {
  for_each  = local.configs
  source    = "./modules/config"
  namespace = local.namespace
  app       = local.app
  service   = each.key
  params    = local.params

  config_files = each.value
}


resource "kubernetes_config_map" "kubeconfig" {
  metadata {
    name      = "kubeconfig"
    namespace = local.namespace
  }
  data = {
    "kubeconfig.conf" = file("${path.module}/files/clouddriver/kubeconfig.conf")
    "get-token.sh"    = file("${path.module}/files/clouddriver/get-token.sh")
  }
}

resource "kubernetes_config_map" "orca" {
  metadata {
    name      = "orca"
    namespace = local.namespace
  }
  data = {
    "shutdown.sh" = file("${path.module}/files/orca/shutdown.sh")
  }
}
resource "kubernetes_config_map" "rosco-packer" {
  metadata {
    name      = "rosco-packer"
    namespace = local.namespace
  }
  data = { for f in fileset("${path.module}/files/rosco/packer/", "*") :
    f => file("${path.module}/files/rosco/packer/${f}")
  }
}
resource "kubernetes_config_map" "rosco-scripts" {
  metadata {
    name      = "rosco-scripts"
    namespace = local.namespace
  }
  data = { for f in fileset("${path.module}/files/rosco/scripts/", "*") :
    f => file("${path.module}/files/rosco/scripts/${f}")
  }
}
