resource "aws_route53_zone" "public" {
  name    = "spinnaker.double.tech."
  comment = "Public zone for spinnaker workloads"
}

resource "aws_route53_zone" "private" {
  name    = "spinnaker.double.tech."
  comment = "Private zone for spinnaker workloads"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}
