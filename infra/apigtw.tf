resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "apigtw-ordering-system-blues-burger"
  description   = "Api gateway do sistema de pedidos"
  protocol_type = "HTTP"

  depends_on = [aws_lambda_function.lambda_pre_authentication, aws_cognito_user_pool.my_user_pool]
}

resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id          = aws_apigatewayv2_api.api_gateway.id
  name            = "cognito-authorizer"
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://${aws_cognito_user_pool.my_user_pool.endpoint}"
    audience = [aws_cognito_user_pool_client.my_user_pool_client.id]
  }
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /{proxy+}"
  //TODO - colocar o target
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev"
  auto_deploy = true
}
