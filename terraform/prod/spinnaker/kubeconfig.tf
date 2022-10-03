resource "local_file" "kubeconfig" {
  file_permission = 0644
  filename        = "${path.module}/files/kubeconfig.conf"
  content = yamlencode({
    apiVersion = "v1"
    kind       = "Config"

    clusters = [
      {
        cluster = {
          certificate-authority-data = module.cluster.eks_ca_data
          server                     = module.cluster.eks_endpoint_url
        }
        name = module.cluster.eks_cluster_name
      }
    ]
    contexts = [{
      context = {
        cluster = module.cluster.eks_cluster_name
        user    = module.cluster.eks_cluster_name
      }
      name = module.cluster.eks_cluster_name
    }]
    current-context = module.cluster.eks_cluster_name
    preferences     = {}
    users = [{
      name = module.cluster.eks_cluster_name
      user = {
        exec = {
          apiVersion = "client.authentication.k8s.io/v1beta1"
          args = [
            "--region",
            "eu-central-1",
            "eks",
            "get-token",
            "--cluster-name",
            "spinnaker-prod",
          ]
          command = "aws"
          env = [
            # { name  = "AWS_PROFILE"
            #   value = "dc-spin"
            # }
          ]
        }
      }
    }]
  })
}
