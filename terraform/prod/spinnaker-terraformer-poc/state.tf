terraform {
  backend "s3" {
    bucket  = "spin-doublecloud"
    key     = "prod/spinnaker-terraformer-poc-eks.tfstate"
    region  = "eu-central-1"
    profile = "yadc-spinnaker"
  }
}
