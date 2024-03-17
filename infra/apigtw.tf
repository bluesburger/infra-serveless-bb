resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "apigtw-ordering-system-blues-burger"
  description = "Api gateway do sistema de pedidos"

  depends_on = [aws_lambda_function.lambda_pre_authentication, aws_cognito_user_pool.my_user_pool]
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

resource "aws_api_gateway_integration" "get_menu_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = "GET"
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "https://www.google.com.br/"
}

resource "aws_api_gateway_method" "get_menu_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method_response" "api_gateway_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.get_menu_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_settings" "example_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "dev"
  method_path = "${aws_api_gateway_resource.api_gateway_resource.path_part}/${aws_api_gateway_method.get_menu_method.http_method}"

   settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }

  depends_on = [aws_api_gateway_stage.aws_apigtw_stage]
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gateway_resource.id,
      aws_api_gateway_method.get_menu_method.id,
      aws_api_gateway_integration.get_menu_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws_apigtw_stage" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = "dev"
}
