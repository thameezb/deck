locals {
  private_dns_zone_id = "Z062959331ELF7L4P20FF"
  public_dns_zone_id  = "Z0782208353IMC9JGIL9Q"

  puncher = {
    "teamcity-prod" = {
      service_name        = "com.amazonaws.vpce.eu-central-1.vpce-svc-0d2ec5ff8fe888fc2"
      private_dns_enabled = true # change to true when it's accepted
    }
    "hub-prod" = {
      service_name        = "com.amazonaws.vpce.eu-central-1.vpce-svc-0b9d06dae959e1fdf"
      private_dns_enabled = true # change to true when it's accepted
    }
  }

  namespace         = "spinnaker"
  secret_store_name = "spinnaker-aws-secrets"
}
