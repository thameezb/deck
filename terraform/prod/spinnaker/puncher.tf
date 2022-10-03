module "puncher" {
  for_each = local.puncher
  source   = "../../modules/puncher/v1"

  name                = each.key
  service_name        = each.value.service_name
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = [for k, v in data.aws_subnet.public : v.id]
  private_dns_enabled = each.value.private_dns_enabled
}
