variable "tags" {
  type = map(string)
}

variable "eks_oidc_url" {
  type = string
}
variable "eks_oidc_arn" {
  type = string
}

variable "acm_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "create_iam" {
  type    = bool
  default = true
}
