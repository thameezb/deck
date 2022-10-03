output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private : k => v.id }
}

output "public_subnets" {
  value = { for k, v in aws_subnet.public : k => v.id }
}

output "nat_igw_arn" {
  value = {
    arn = aws_internet_gateway.this.arn
  }
}

output "nat_gw_ip" {
  value = {
    public  = aws_nat_gateway.this.public_ip
    private = aws_nat_gateway.this.private_ip
  }
}

output "endpoints" {
  value = {
    secretsmanager = aws_vpc_endpoint.secretsmanager.id
  }
}
