variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "eks_ip_family" {
  type    = string
  default = "ipv4"
}

variable "private_nodes_desired_size" {
  type    = number
  default = 1
}
variable "private_nodes_max_size" {
  type    = number
  default = 1
}
variable "private_nodes_min_size" {
  type    = number
  default = 1
}

variable "public_nodes_desired_size" {
  type    = number
  default = 1
}

variable "public_nodes_max_size" {
  type    = number
  default = 1
}

variable "public_nodes_min_size" {
  type    = number
  default = 1
}

variable "public_nodes_release_version" {
  type    = string
  default = null
}

variable "public_nodes_instance_tags" {
  type    = map(string)
  default = {}
}

variable "thumbprint_list" {
  type    = list(string)
  default = []
}

variable "teleport" {
  type = object({
    enabled       = optional(bool)
    version       = optional(string)
    chart_version = optional(string)
    cluster_name  = optional(string)
    account_id    = optional(string)
    region_name   = optional(string)
    installation = optional(object({
      account = string
      env     = string
      plane   = string
    }))
    dbs = optional(list(object({
      type    = string
      regions = list(string)
      tags    = map(string)
    })))
    apps = optional(list(object({
      name = string
      uri  = string
    })))
    ec2 = optional(object({
      enabled   = bool
      regions   = optional(list(string))
      installer = optional(string)
      tags      = optional(any)
    }))
  })

  default = {
    enabled = false
  }
}

