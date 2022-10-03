locals {
  private_tags = merge(var.vpc_private_subnet_tags, var.vpc_tags)
  public_tags  = merge(var.vpc_public_subnet_tags, var.vpc_tags)

  nat_gw_zone_name = element(keys(var.public_subnets), 0)
  nat_gw_zone      = var.public_subnets[local.nat_gw_zone_name]
}
