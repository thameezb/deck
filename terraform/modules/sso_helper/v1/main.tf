data "aws_iam_role" "this" {
  name = var.role_name
}

data "aws_arn" "role_full" {
  arn = data.aws_iam_role.this.arn
}

locals {
  partition = data.aws_arn.role_full.partition
  service   = data.aws_arn.role_full.service
  region    = data.aws_arn.role_full.region
  account   = data.aws_arn.role_full.account
  resource  = data.aws_arn.role_full.resource

  resource_path_items = split("/", local.resource)
  resource_type       = element(local.resource_path_items, 0)
  resource_name       = element(local.resource_path_items, length(local.resource_path_items) - 1)

}
