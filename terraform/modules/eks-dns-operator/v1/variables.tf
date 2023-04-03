variable "aws_dns_public_zone_id" {
  type = string
}

variable "eks_oidc_url" {
  type = string
}
variable "eks_oidc_arn" {
  type = string
}

variable "create_iam" {
  type    = bool
  default = true
}
