resource "aws_cognito_user_pool" "my_user_pool" {
  name = "blues-burger-user-pool"
}

resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name                     = "blues-burger-app-client"
  user_pool_id             = aws_cognito_user_pool.my_user_pool.id
}
