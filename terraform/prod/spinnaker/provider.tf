provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "this" {
  name = module.cluster.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.cluster.eks_endpoint_url
  cluster_ca_certificate = base64decode(module.cluster.eks_ca_data)
  # token                  = data.aws_eks_cluster_auth.this.token # it doesnt work with an import step
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.cluster.eks_cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.eks_endpoint_url
    cluster_ca_certificate = base64decode(module.cluster.eks_ca_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }

}
