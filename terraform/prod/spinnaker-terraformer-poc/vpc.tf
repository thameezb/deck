data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["spin-vpc"]
  }
}

data "aws_region" "this" {}

data "aws_subnet" "private" {
  for_each = toset(["a", "b", "c"])

  filter {
    name   = "tag:Group"
    values = ["spin"]
  }
  filter {
    name   = "availabilityZone"
    values = ["${data.aws_region.this.id}${each.value}"]
  }
  filter {
    name   = "tag:Class"
    values = ["private"]
  }
}
