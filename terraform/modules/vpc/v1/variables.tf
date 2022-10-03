# TODO: add variables required in this module

variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type        = map(object({ v4_cidr = number, v6_cidr = number }))
  description = "The map of subnets, zone => { v4_cidr = cidr_index, v6_cidr = cidr_index }"
}

variable "private_subnets" {
  type        = map(object({ v4_cidr = number, v6_cidr = number }))
  description = "The map of subnets, zone => { v4_cidr = cidr_index, v6_cidr = cidr_index }"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_support" {
  type    = bool
  default = false
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "vpc_tags" {
  type    = map(string)
  default = {}
}
variable "vpc_public_subnet_tags" {
  type    = map(string)
  default = {}
}
variable "vpc_private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "public_access_allow_list_v4" {
  type    = list(string)
  default = []
}

variable "public_access_allow_list_v6" {
  type    = list(string)
  default = []
}

variable "private_dns_hostname_type_on_launch" {
  type    = string
  default = "ip-name"
}

variable "ipv6" {
  type    = bool
  default = false
}
