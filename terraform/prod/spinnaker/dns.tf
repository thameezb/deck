data "aws_route53_zone" "private" {
  zone_id = local.private_dns_zone_id
}

data "aws_route53_zone" "public" {
  zone_id = local.public_dns_zone_id
}
