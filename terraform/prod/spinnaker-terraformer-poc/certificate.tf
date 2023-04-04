module "certificate" {
  source      = "../../modules/certificate/v1"
  domain_name = aws_route53_zone.public.name
  zone_id     = aws_route53_zone.public.id
}
