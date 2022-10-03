variable "vpc_id" {
  type = string
}
variable "service_name" {
  type = string
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "name" {
  type = string
}

variable "ports" {
  type    = list(string)
  default = ["80", "443"]
}

variable "private_dns_enabled" {
  type    = bool
  default = true
}
