# common
variable "namespace" {
  description = "Kubernetes namespace for spinnaker services"
  type        = string
  default     = "spinnaker"
}

variable "service" {
  type = string
}

variable "app" {
  type = string
}

variable "config_files" {
  type = list(string)
}

variable "params" {
  type = object({
    gate_host = string
    gate_path = string
    deck_host = string
    # mysql_host = string

    # plugins = string

    # spinnaker   = string
    echo = object({
      mail_enabled = bool
      mail_from    = string
      mail_host    = string
      mail_port    = string

      slack_enabled = bool
    })

    front50 = object({
      s3_bucket = string
      s3_region = string
    })

    saml_enabled      = string
    saml_issuer_id    = string
    saml_metadata_url = string

    oauth_enabled          = string
    oauth_client_id        = string
    access_token_uri       = string
    user_authorization_uri = string
    user_info_uri          = string
  })
}
