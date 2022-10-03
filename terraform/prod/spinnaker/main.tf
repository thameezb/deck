module "spinnaker" {
  depends_on = [module.eks_ingress]
  source     = "../../modules/spinnaker/v1"

  acm_arn      = module.certificate.certificate_arn
  saml_enabled = true
  s3_region    = module.bucket.region
  s3_bucket    = module.bucket.bucket

  eks_oidc_url = module.cluster.eks_oidc_url
  eks_oidc_arn = module.cluster.eks_oidc_arn
}

module "certificate" {
  source      = "../../modules/certificate/v1"
  domain_name = data.aws_route53_zone.public.name
  zone_id     = data.aws_route53_zone.public.id
}

module "eks_dns" {
  source                 = "../../modules/eks-dns-operator/v1"
  aws_dns_public_zone_id = local.public_dns_zone_id
  eks_oidc_url           = module.cluster.eks_oidc_url
  eks_oidc_arn           = module.cluster.eks_oidc_arn
}

module "eks_eso" {
  source       = "../../modules/eks-secret-operator/v1"
  eks_oidc_url = module.cluster.eks_oidc_url
  eks_oidc_arn = module.cluster.eks_oidc_arn
  region       = var.region
  account_id   = "022615369514"
}

module "eks_ingress" {
  source       = "../../modules/eks-ingress/v1"
  tags         = { "Name" = "spinnaker-prod" }
  eks_oidc_url = module.cluster.eks_oidc_url
  eks_oidc_arn = module.cluster.eks_oidc_arn
  acm_arn      = module.certificate.certificate_arn
  cluster_name = module.cluster.eks_cluster_name
  region       = var.region
  vpc_id       = data.aws_vpc.this.id
}
