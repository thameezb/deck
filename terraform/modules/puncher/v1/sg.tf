data "aws_vpc" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}_endpoint_sg"
  description = "Allow traffic to required ports"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress_v4" {
  for_each          = toset(var.ports)
  security_group_id = aws_security_group.this.id
  from_port         = each.value
  protocol          = "tcp"
  to_port           = each.value
  type              = "ingress"
  cidr_blocks       = [data.aws_vpc.this.cidr_block]
}

resource "aws_security_group_rule" "ingress_v6" {
  for_each          = toset(var.ports)
  security_group_id = aws_security_group.this.id
  from_port         = each.value
  protocol          = "tcp"
  to_port           = each.value
  type              = "ingress"
  ipv6_cidr_blocks  = [data.aws_vpc.this.ipv6_cidr_block]
}

resource "aws_security_group_rule" "egress-v4" {
  security_group_id = aws_security_group.this.id
  from_port         = -1
  protocol          = "all"
  to_port           = -1
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress-v6" {
  security_group_id = aws_security_group.this.id
  from_port         = -1
  protocol          = "all"
  to_port           = -1
  type              = "egress"
  ipv6_cidr_blocks  = ["::/0"]
}
