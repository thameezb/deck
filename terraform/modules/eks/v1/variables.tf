variable "name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.22"
}

variable "vpc_id" {
  type = string
}

variable "node_vpc_type" {
  type    = string
  default = "public"
}

# retaining due to backward compatibility, this should be removed 
variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "node_subnet_ids" {
  type    = list(string)
  default = []
}

variable "eks_ip_family" {
  type    = string
  default = "ipv4"
}

variable "node_desired_size" {
  type    = number
  default = 1
}
variable "node_max_size" {
  type    = number
  default = 1
}
variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_instance_tags" {
  type    = map(string)
  default = {}
}

variable "node_release_version" {
  type    = string
  default = ""
}

variable "thumbprint_list" {
  type    = list(string)
  default = []
}

variable "instance_types" {
  type    = list(string)
  default = ["m6a.xlarge"]
}

variable "teleport" {
  type = object({
    enabled               = optional(bool)
    version               = optional(string)
    chart_version         = optional(string)
    cluster_name          = optional(string)
    cluster_name_override = optional(string)
    account_id            = optional(string)
    region_name           = optional(string)
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

variable "create_iam" {
  type    = bool
  default = true
}

variable "create_launch_template" {
  type    = bool
  default = true
}
