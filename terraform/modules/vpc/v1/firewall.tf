resource "aws_network_acl" "this" {
  vpc_id = aws_vpc.this.id

  subnet_ids = [for k, v in aws_subnet.public : v.id]
  tags = {
    Name = "${var.vpc_name}-nacl"
  }
}

# Allow egress without restrictions
resource "aws_network_acl_rule" "egress-v4" {
  network_acl_id = aws_network_acl.this.id

  egress      = true
  protocol    = "-1"
  rule_number = 101
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}

resource "aws_network_acl_rule" "egress-v6" {
  network_acl_id = aws_network_acl.this.id

  egress          = true
  protocol        = "-1"
  rule_number     = 102
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 0
  to_port         = 0
}


# Allow ingress without restrictions within same network
resource "aws_network_acl_rule" "ingress-v4" {
  network_acl_id = aws_network_acl.this.id

  protocol = "-1"

  rule_number = 103
  rule_action = "allow"
  cidr_block  = aws_vpc.this.cidr_block
  from_port   = 0
  to_port     = 0
}
resource "aws_network_acl_rule" "ingress-v6" {
  network_acl_id = aws_network_acl.this.id

  protocol = "-1"

  rule_number     = 104
  rule_action     = "allow"
  ipv6_cidr_block = aws_vpc.this.ipv6_cidr_block
  from_port       = 0
  to_port         = 0
}

# Allow ingress without restrictions on ephemeral port range
resource "aws_network_acl_rule" "ingress-ephemeral-v4" {
  network_acl_id = aws_network_acl.this.id

  protocol    = "tcp"
  rule_number = 1
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 1024
  to_port     = 65535
}
resource "aws_network_acl_rule" "ingress-ephemeral-v6" {
  network_acl_id = aws_network_acl.this.id

  protocol        = "tcp"
  rule_number     = 2
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
  from_port       = 1024
  to_port         = 65535
}


# Allow ingress for allow list
resource "aws_network_acl_rule" "ingress-custom-v4" {
  for_each = toset(var.public_access_allow_list_v4)

  network_acl_id = aws_network_acl.this.id

  protocol    = "-1"
  rule_number = index(var.public_access_allow_list_v4, each.key) + 200
  rule_action = "allow"
  cidr_block  = each.key
  from_port   = 0
  to_port     = 0
}
resource "aws_network_acl_rule" "ingress-custom-v6" {
  for_each = toset(var.public_access_allow_list_v6)

  network_acl_id = aws_network_acl.this.id

  protocol        = "-1"
  rule_number     = index(var.public_access_allow_list_v6, each.key) + 300
  rule_action     = "allow"
  ipv6_cidr_block = each.key
  from_port       = 0
  to_port         = 0
}
