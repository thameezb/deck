module "saml" {
  source = "../../modules/eso-secret/v1"

  name      = "saml"
  namespace = local.namespace

  secret_store_name = local.secret_store_name

  # keytool -genkey -v -keystore saml.jks -alias saml -keyalg RSA -keysize 2048 -validity 10000
  # aws --profile yadc-spinnaker secretsmanager put-secret-value --secret-string '{"password": "xxxx"}' --secret-id saml
  # aws --profile yadc-spinnaker secretsmanager create-secret --name saml-jks --secret-binary fileb://saml.jks
  data = [
    {
      secretKey = "password"
      remoteRef = {
        key      = "saml"
        property = "password"
      }
    },
    {
      secretKey = "saml.jks"
      remoteRef = {
        key      = "saml-jks"
        property = ""
      }
    },
  ]
}
module "aws_cred" {
  source = "../../modules/eso-secret/v1"

  name      = "aws-s3-cred"
  namespace = local.namespace

  secret_store_name = local.secret_store_name

  # keytool -genkey -v -keystore saml.jks -alias saml -keyalg RSA -keysize 2048 -validity 10000
  # aws --profile yadc-spinnaker secretsmanager put-secret-value --secret-string '{"password": "xxxx"}' --secret-id saml
  # aws --profile yadc-spinnaker secretsmanager create-secret --name saml-jks --secret-binary fileb://saml.jks
  data = [
    {
      secretKey = "access_key_id"
      remoteRef = {
        key      = "spinnaker-aws-cred"
        property = "access_key_id"
      }
    },
    {
      secretKey = "secret_access_key"
      remoteRef = {
        key      = "spinnaker-aws-cred"
        property = "secret_access_key"
      }
    },
  ]
}
module "teamcity_tokens" {
  source = "../../modules/eso-secret/v1"

  name      = "teamcity"
  namespace = local.namespace

  secret_store_name = local.secret_store_name

  # create token on https://teamcity.aw.double.tech/profile.html?item=accessTokens#
  # aws --profile yadc-spinnaker secretsmanager create-secret --name teamcity-tokens --secret-string '{"aw_token": "xxx"}
  # aws --profile yadc-spinnaker secretsmanager put-secret-value --secret-string '{"foo_bar": "xxxx"}' --secret-id teamcity-tokens
  data = [
    {
      secretKey = "aw_token"
      remoteRef = {
        key      = "teamcity-tokens"
        property = "aw_token"
      }
    },
  ]
}
