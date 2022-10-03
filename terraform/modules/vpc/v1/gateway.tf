# Internet Gateway (IGW) allows instances with public IPs to access the internet.
resource "aws_internet_gateway" "this" {
  vpc_id   = aws_vpc.this.id
  tags     = { "Name" = "${var.vpc_name}-igw" }
  tags_all = { "Name" = "${var.vpc_name}-igw" }
}


# Elastic IP to enable access to Internet via NAT GW
resource "aws_eip" "this" {
  vpc = true

  tags = { "Name" = "${var.vpc_name}-nat-gw-eip" }
}

# NAT Gateway (NGW) allows instances with no public IPs to access the internet.
resource "aws_nat_gateway" "this" {
  allocation_id     = aws_eip.this.id
  subnet_id         = aws_subnet.public[local.nat_gw_zone_name].id
  connectivity_type = "public"
  tags              = { "Name" = "${var.vpc_name}-${local.nat_gw_zone_name}" }
  tags_all          = { "Name" = "${var.vpc_name}-${local.nat_gw_zone_name}" }
}

resource "aws_egress_only_internet_gateway" "this" {
  vpc_id   = aws_vpc.this.id
  tags     = { "Name" = "${var.vpc_name}-egress" }
  tags_all = { "Name" = "${var.vpc_name}-egress" }
}
