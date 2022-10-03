output "bucket" {
  value = module.tfinfra.bucket
}

output "state_role" {
  value = module.tfinfra.state_role
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}

output "nat_gw" {
  value = module.vpc.nat_gw_ip
}

output "internet_gw" {
  value = module.vpc.nat_igw_arn
}

output "endpoints" {
  value = module.vpc.endpoints
}
output "public_name_servers" {
  value = aws_route53_zone.public.name_servers
}
output "dns_hosted_zone_id" {
  value = {
    public  = aws_route53_zone.public.id
    private = aws_route53_zone.private.id
  }
}
