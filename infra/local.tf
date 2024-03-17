locals {
  lambda_pre_authentication_arn  = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.function_name}"
  uri_integration_apigtw_cognito = "arn:aws:cognito-idp:us-east-1:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.my_user_pool.id}"

}