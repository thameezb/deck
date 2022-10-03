module "tfinfra" {
  source      = "../modules/tfinfra/v1"
  bucket_name = "spin-doublecloud"
  aws_principals = [
    local.aws_accounts.spinnaker,
  ]
  state_principals = [
    local.aws_accounts.spinnaker,
  ]
}


resource "aws_servicequotas_service_quota" "rules_per_network" {
  quota_code   = "L-2AEEBF1A"
  service_code = "vpc"
  value        = 40
}

module "vpc" {
  source = "../modules/vpc/v1"
  depends_on = [
    aws_servicequotas_service_quota.rules_per_network,
  ]

  vpc_name   = "spin-vpc"
  cidr_block = "10.67.0.0/16"

  enable_dns_hostnames                = true
  enable_dns_support                  = true
  private_dns_hostname_type_on_launch = "resource-name"

  ipv6 = true

  private_subnets = {
    "${var.region}a" = { v4_cidr = 1, v6_cidr = 1 }
    "${var.region}b" = { v4_cidr = 2, v6_cidr = 2 }
    "${var.region}c" = { v4_cidr = 3, v6_cidr = 3 }
  }
  public_subnets = {
    "${var.region}a" = { v4_cidr = 10, v6_cidr = 10 }
    "${var.region}b" = { v4_cidr = 20, v6_cidr = 20 }
    "${var.region}c" = { v4_cidr = 30, v6_cidr = 30 }
  }
  vpc_tags = {
    Group = "spin"
  }
  vpc_public_subnet_tags = {
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/spinnaker-prod" = "shared"
  }
  # Extra quota has been requested
  public_access_allow_list_v6 = [
    "2001:4d78:51b::/48",
    "2620:10f:d000::/44",
    "2a02:6b8::/32",
    "2a0e:fd80::/29",
  ]
  public_access_allow_list_v4 = [
    "5.45.192.0/18",
    "5.255.192.0/18",
    "37.9.64.0/18",
    "37.140.128.0/18",
    "45.87.132.0/22",
    "77.88.0.0/18",
    "84.252.160.0/19",
    "87.250.224.0/19",
    "90.156.176.0/22",
    "93.158.128.0/18",
    "95.108.128.0/17",
    "100.43.64.0/19",
    "139.45.249.96/29", # https://st.yandex-team.ru/NOCREQUESTS-25161
    "141.8.128.0/18",
    "178.154.128.0/18",
    "185.32.187.0/24",
    "199.21.96.0/22",
    "199.36.240.0/22",
    "213.52.188.0/25",
    "213.180.192.0/19",
  ]
}
