resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  instance_tenancy                 = var.instance_tenancy
  assign_generated_ipv6_cidr_block = var.ipv6

  tags     = merge(var.vpc_tags, { "Name" = var.vpc_name })
  tags_all = merge(var.vpc_tags, { "Name" = var.vpc_name })
}
