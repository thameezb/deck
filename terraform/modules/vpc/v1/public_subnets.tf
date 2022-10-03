resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value.v4_cidr)
  ipv6_cidr_block = var.ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.value.v6_cidr) : null

  map_public_ip_on_launch = true

  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = var.ipv6

  assign_ipv6_address_on_creation = var.ipv6

  tags = merge(local.public_tags, {
    "Name"  = "${var.vpc_name}-public-${each.key}"
    "Class" = "public"
    "Zone"  = each.key
  })
  tags_all = merge(local.public_tags, {
    "Name"  = "${var.vpc_name}-public-${each.key}"
    "Class" = "public"
    "Zone"  = each.key
  })
}

# Public Subnets Routing Table
resource "aws_route_table" "public" {
  vpc_id   = aws_vpc.this.id
  tags     = { "Name" = "${var.vpc_name}-public" }
  tags_all = { "Name" = "${var.vpc_name}-public" }
}

resource "aws_route" "public_v4" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "public_v6" {
  route_table_id              = aws_route_table.public.id
  gateway_id                  = aws_internet_gateway.this.id
  destination_ipv6_cidr_block = "::/0"
}

# Public Subnets to Routing Table Associations
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}
