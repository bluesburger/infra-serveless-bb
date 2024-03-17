locals {
  lambda_name_signup_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name_signup}"
  lambda_name_define_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name_define}"
  lambda_name_create_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name_create}"
  lambda_name_verify_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name_verify}"

  uri_integration_apigtw_cognito = "arn:aws:cognito-idp:us-east-1:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.my_user_pool.id}"
}