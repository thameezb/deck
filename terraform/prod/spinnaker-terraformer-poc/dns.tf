resource "aws_route53_zone" "public" {
  name    = "spinnaker-poc.yadc.tech."
  comment = "Public zone for ${local.cluster_name}. workloads"
}
