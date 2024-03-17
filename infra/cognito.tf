resource "aws_cognito_user_pool" "my_user_pool" {
  name = "blues-burger-user-pool"

  lambda_config {
    define_auth_challenge          = local.lambda_name_define_arn
    create_auth_challenge          = local.lambda_name_create_arn
    verify_auth_challenge_response = local.lambda_name_verify_arn
    pre_sign_up                    = local.lambda_name_signup_arn
  }

  schema {
    name                = "cpf"
    attribute_data_type = "String"
  }
}

resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name         = "blues-burger-app-client"
  user_pool_id = aws_cognito_user_pool.my_user_pool.id
}

