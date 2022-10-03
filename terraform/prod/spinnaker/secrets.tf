module "saml" {
  source = "../../modules/eso-secret/v1"

  name      = "saml"
  namespace = local.namespace

  secret_store_name = local.secret_store_name

  # keytool -genkey -v -keystore saml.jks -alias saml -keyalg RSA -keysize 2048 -validity 10000
  # aws --profile dc-spin secretsmanager put-secret-value --secret-string '{"password": "xxxx"}' --secret-id saml
  # aws --profile dc-spin secretsmanager create-secret --name saml-jks --secret-binary fileb://saml.jks
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
  # aws --profile dc-spin secretsmanager put-secret-value --secret-string '{"password": "xxxx"}' --secret-id saml
  # aws --profile dc-spin secretsmanager create-secret --name saml-jks --secret-binary fileb://saml.jks
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
