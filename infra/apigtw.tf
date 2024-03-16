resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "gtw-blues-burger"
  description = "Api gateway do sistema de pedidos"
}

resource "aws_api_gateway_resource" "api_gateway_resource" {
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "endpoint"
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name          = var.function_name
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  authorizer_uri = aws_lambda_function.lambda_authorizer.invoke_arn
  identity_source = "method.request.header.Authorization"
  type          = "TOKEN"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.my_user_pool.arn]
}

resource "aws_api_gateway_method" "cognito_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_authorizer.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/*/*"
}

resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_authorizer.invoke_arn
}

#resource "aws_api_gateway_integration" "get-menu" {
#  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
#  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
#  http_method             = aws_api_gateway_method.api_gateway_method.http_method
#  integration_http_method = "GET"
#  type                    = "HTTP_PROXY"
#  uri                     = "alterar_url_para_ecs"
#}
#
#resource "aws_api_gateway_method_response" "java_api_method_response" {
#  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#  resource_id = aws_api_gateway_resource.api_gateway_resource.id
#  http_method = aws_api_gateway_method.api_gateway_method.http_method
#  status_code = "200"
#
#  response_models = {
#    "application/json" = "Empty"
#  }
#}
#
#resource "aws_api_gateway_integration_response" "java_api_integration_response" {
#  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#  resource_id = aws_api_gateway_resource.api_gateway_resource.id
#  http_method = aws_api_gateway_method.api_gateway_method.http_method
#  status_code = aws_api_gateway_method_response.java_api_method_response.status_code
#
#  response_templates = {
#    "application/json" = ""
#  }
#}
