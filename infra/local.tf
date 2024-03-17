locals {
  lambda_pre_authentication_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.function_name}"
}