variable "region" {
  type        = string
  description = "The region where the resources will be located"
  default     = "eu-central-1"
}

variable "armorycd_version" {
  type    = string
  default = "2.28.5"
}

variable "spinnaker_irsa_assume_role_arn" {
  type    = string
  default = ""
}
