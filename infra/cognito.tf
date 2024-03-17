resource "aws_cognito_user_pool" "my_user_pool" {
  name = "blues-burger-user-pool"

  lambda_config {
    pre_authentication = local.lambda_pre_authentication_arn
  }

  schema {
    name                = "cpf"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }
}

resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name         = "blues-burger-app-client"
  user_pool_id = aws_cognito_user_pool.my_user_pool.id
}

resource "aws_cognito_user_pool_trigger" "example_pre_authentication_trigger" {
  user_pool_id = aws_cognito_user_pool.my_user_pool.id
  trigger_name = "PreAuthentication"

  lambda_function_name = local.lambda_pre_authentication_arn
}
