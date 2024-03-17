resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "apigtw-ordering-system-blues-burger"
  description = "Api gateway do sistema de pedidos"

  depends_on = [aws_lambda_function.lambda_pre_authentication]
}

resource "aws_api_gateway_resource" "api_gateway_resource" {
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                  = "cognito-authorizer"
  type                  = "COGNITO_USER_POOLS"
  rest_api_id           = aws_api_gateway_rest_api.api_gateway.id
  identity_source       = "method.request.header.Authorization"
  provider_arns         = [aws_cognito_user_pool.my_user_pool.arn]
}

resource "aws_api_gateway_method" "cognito_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method_response" "cognito_api_gateway_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.cognito_api_gateway_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "api_gateway_integration_cognito" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.cognito_api_gateway_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_cognito_user_pool.my_user_pool.arn
}

resource "aws_api_gateway_method_settings" "example_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "dev"
  method_path = "${aws_api_gateway_resource.api_gateway_resource.path_part}/${aws_api_gateway_method.cognito_api_gateway_method.http_method}"

   settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }
}
