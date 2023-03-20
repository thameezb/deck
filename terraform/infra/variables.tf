variable "region" {
  type        = string
  description = "The region where the resources will be located"
  default     = "eu-central-1"
}

variable "profile" {
  type        = string
  description = "The name of the profile that is configured to access"
  default     = "yadc-spinnaker"
}
