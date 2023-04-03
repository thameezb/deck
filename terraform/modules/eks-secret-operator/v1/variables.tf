variable "eks_oidc_url" {
  type = string
}

variable "eks_oidc_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "create_iam" {
  type    = bool
  default = true
}
