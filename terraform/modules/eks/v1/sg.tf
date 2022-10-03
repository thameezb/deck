data "aws_vpc" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

### cluster
resource "aws_security_group" "cluster" {
  name   = var.name
  vpc_id = var.vpc_id
}


resource "aws_security_group_rule" "cluster-self" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.cluster.id

  from_port = -1
  protocol  = "all"
  to_port   = -1
  type      = each.key
  self      = true
}

resource "aws_security_group_rule" "cluster-self-v4" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.cluster.id

  from_port   = -1
  protocol    = "all"
  to_port     = -1
  type        = each.key
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}

resource "aws_security_group_rule" "cluster-self-v6" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.cluster.id

  from_port        = -1
  protocol         = "all"
  to_port          = -1
  type             = each.key
  ipv6_cidr_blocks = [data.aws_vpc.this.ipv6_cidr_block]
}


resource "aws_security_group_rule" "cluster-public-v4-egress" {
  security_group_id = aws_security_group.cluster.id

  from_port   = -1
  protocol    = "all"
  to_port     = -1
  type        = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "cluster-public-v6-egress" {
  security_group_id = aws_security_group.cluster.id

  from_port        = -1
  protocol         = "all"
  to_port          = -1
  type             = "egress"
  ipv6_cidr_blocks = ["::/0"]
}


### nodes
resource "aws_security_group" "node" {
  name   = "${var.name}-node"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "node-self" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.node.id

  from_port = -1
  protocol  = "all"
  to_port   = -1
  type      = each.key
  self      = true
}

resource "aws_security_group_rule" "node-self-v4" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.node.id

  from_port   = -1
  protocol    = "all"
  to_port     = -1
  type        = each.key
  cidr_blocks = [data.aws_vpc.this.cidr_block]
}

resource "aws_security_group_rule" "node-self-v6" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = aws_security_group.node.id

  from_port        = -1
  protocol         = "all"
  to_port          = -1
  type             = each.key
  ipv6_cidr_blocks = [data.aws_vpc.this.ipv6_cidr_block]
}


resource "aws_security_group_rule" "node-public-v4-egress" {
  security_group_id = aws_security_group.node.id

  from_port   = -1
  protocol    = "all"
  to_port     = -1
  type        = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-public-v6-egress" {
  security_group_id = aws_security_group.node.id

  from_port        = -1
  protocol         = "all"
  to_port          = -1
  type             = "egress"
  ipv6_cidr_blocks = ["::/0"]
}
