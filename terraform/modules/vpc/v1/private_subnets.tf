resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value.v4_cidr)
  ipv6_cidr_block = var.ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.value.v6_cidr) : null

  map_public_ip_on_launch = false

  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = var.ipv6

  assign_ipv6_address_on_creation = var.ipv6

  tags = merge(local.private_tags, {
    "Name"  = "${var.vpc_name}-private-${each.key}"
    "Class" = "private"
    "Zone"  = each.key
  })
  tags_all = merge(local.private_tags, {
    "Name"  = "${var.vpc_name}-private-${each.key}"
    "Class" = "private"
    "Zone"  = each.key
  })
}

# Private Subnets Routing Table
resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.this.id
  tags     = { "Name" = "${var.vpc_name}-private" }
  tags_all = { "Name" = "${var.vpc_name}-private" }
}

# Private Route
resource "aws_route" "private_v4" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route" "private_v6" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this.id
}

# Private Subnets to Routing Table Associations
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}
