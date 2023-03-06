terraform {
  backend "s3" {
    bucket  = "spin-doublecloud"
    key     = "prod/spin-eks.tfstate"
    region  = "eu-central-1"
    profile = "yadc-spinnaker"
  }
}
