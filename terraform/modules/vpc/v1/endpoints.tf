resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.eu-central-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags = {
    "Name" = "secretsmanager"
    "Type" = "public"
  }
}

resource "aws_vpc_endpoint_subnet_association" "public" {
  for_each        = aws_subnet.public
  subnet_id       = each.value.id
  vpc_endpoint_id = aws_vpc_endpoint.secretsmanager.id
}

resource "aws_vpc_endpoint_security_group_association" "secretsmanager" {
  security_group_id = aws_security_group.secretsmanager.id
  vpc_endpoint_id   = aws_vpc_endpoint.secretsmanager.id
}
resource "aws_security_group" "secretsmanager" {
  name   = "secretsmanager"
  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "secretsmanager-public" {
  security_group_id = aws_security_group.secretsmanager.id

  type        = "ingress"
  from_port   = 0
  protocol    = "tcp"
  to_port     = 443
  cidr_blocks = [for k, v in aws_subnet.public : v.cidr_block]
}
