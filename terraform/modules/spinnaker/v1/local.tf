locals {
  common_configs = ["spinnaker.yml", "logback.xml", ]
  configs = {
    spin-gate        = concat(local.common_configs, ["gate.yml", "gate-local.yml"])
    spin-clouddriver = concat(local.common_configs, ["clouddriver.yml"])
    spin-orca        = concat(local.common_configs, ["orca.yml"])
    spin-fiat        = concat(local.common_configs, ["fiat.yml"])
    spin-echo        = concat(local.common_configs, ["echo.yml"])
    spin-front50     = concat(local.common_configs, ["front50.yml"])
    spin-rosco       = concat(local.common_configs, ["rosco.yml"])
    spin-deck        = ["settings.js"]
  }
  namespace = kubernetes_namespace.this.id

  params = {
    gate_host = var.gate_host
    gate_path = var.gate_path

    deck_host = var.deck_host
    # mysql_host = var.mysql_host

    # plugins = var.plugins

    # spinnaker   = var.spinnaker
    echo = {
      mail_enabled = false
      mail_from    = ""
      mail_host    = ""
      mail_port    = ""

      slack_enabled = false
    }

    front50 = {
      s3_bucket = var.s3_bucket
      s3_region = var.s3_region
    }

    saml_enabled      = var.saml_enabled
    saml_issuer_id    = var.saml_issuer_id
    saml_metadata_url = var.saml_metadata_url

    oauth_enabled          = var.oauth_enabled
    oauth_client_id        = var.oauth_client_id
    access_token_uri       = var.access_token_uri
    user_authorization_uri = var.user_authorization_uri
    user_info_uri          = var.user_info_uri
  }
  app         = "spin"
  clouddriver = "spin-clouddriver"
  gate        = "spin-gate"

  # images
  clouddriver_image = var.clouddriver_image
  deck_image        = var.deck_image
  gate_image        = var.gate_image
  orca_image        = var.orca_image
  rosco_image       = var.rosco_image
  echo_image        = var.echo_image
  front50_image     = var.front50_image
  fiat_image        = var.fiat_image
  redis_image       = var.redis_image
}
