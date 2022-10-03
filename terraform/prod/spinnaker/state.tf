terraform {
  backend "s3" {
    bucket = "spin-doublecloud"
    key    = "prod/spin-eks.tfstate"
    region = "eu-central-1"

    role_arn     = "arn:aws:iam::022615369514:role/terraform-backend"
    session_name = "terraform-state"

    # use AWS_PROFILE=<your profile> instead of
    # profile  = "dc-prod"


    # skip_requesting_account_id  = true
    # skip_credentials_validation = true
    # skip_get_ec2_platforms      = true
    # skip_metadata_api_check     = true
  }
}
