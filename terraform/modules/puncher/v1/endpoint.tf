resource "aws_vpc_endpoint" "this" {
  vpc_id             = var.vpc_id
  service_name       = var.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.this.id]
  tags               = { Name = var.name }

  private_dns_enabled = var.private_dns_enabled

  ip_address_type = "dualstack"
  dns_options {
    dns_record_ip_type = "dualstack"
  }
  #   dns_record_ip_type  = "service-defined"
}
