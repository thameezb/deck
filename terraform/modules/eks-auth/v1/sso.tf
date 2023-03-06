module "sso_users" {
  for_each  = var.sso_users
  source    = "../../sso_helper/v1"
  role_name = each.value
  user_name = each.key
}
