# common
variable "k8s_namespace" {
  description = "Kubernetes namespace for spinnaker services"
  type        = string
  default     = "spinnaker"
}

variable "acm_arn" {
  type = string
}

# config

variable "gate_host" {
  type    = string
  default = "spinnaker.double.tech"
}

variable "gate_path" {
  type    = string
  default = "/gate"
}

variable "deck_host" {
  type    = string
  default = "spinnaker.double.tech"
}

## saml

variable "saml_enabled" {
  type    = bool
  default = false
}

variable "saml_issuer_id" {
  type    = string
  default = "spinnaker"
}

variable "saml_metadata_url" {
  type    = string
  default = "https://hub.aw.double.tech/hub/api/rest/saml2/metadata"
}

## oauth

variable "oauth_enabled" {
  type    = bool
  default = false
}

variable "oauth_client_id" {
  type    = string
  default = ""
}

variable "access_token_uri" {
  type    = string
  default = ""
}

variable "user_authorization_uri" {
  type    = string
  default = ""
}

variable "user_info_uri" {
  type    = string
  default = ""
}


# clouddriver

variable "clouddriver_replicas" {
  type    = number
  default = 1
}

# front50

variable "s3_bucket" {
  type = string
}

variable "s3_region" {
  type = string
}

### images

variable "echo_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/echo:2.34.5"
}

variable "clouddriver_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/clouddriver:5.76.4"
}

variable "deck_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/deck:3.9.3"
}

variable "fiat_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/fiat:1.31.4"
}

variable "front50_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/front50:2.25.4"
}

variable "gate_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/gate:6.55.4"
}

variable "igor_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/igor:4.7.4"
}

variable "kayenta_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/kayenta:2.32.4"
}

variable "orca_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/orca:8.24.5"
}

variable "rosco_image" {
  type    = string
  default = "us-docker.pkg.dev/spinnaker-community/docker/rosco:1.8.6"
}

variable "redis_image" {
  type    = string
  default = "gcr.io/kubernetes-spinnaker/redis-cluster:v2"
}

# oidc

variable "eks_oidc_url" {
  type = string
}
variable "eks_oidc_arn" {
  type = string
}
