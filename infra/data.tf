data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_pre_signup_package" {
  type        = "zip"
  source_dir = "${path.module}/../app/signup/"
  output_path = "${path.module}/zip/lambda_auto_confirm_user.zip"
}

data "archive_file" "python_lambda_define_auth_package" {
  type        = "zip"
  source_dir  = "${path.module}/../app/defineauth/"
  output_path = "${path.module}/zip/lambda_define_auth_challenge.zip"
}

data "archive_file" "python_lambda_create_auth_package" {
  type        = "zip"
  source_dir  = "${path.module}/../app/createauth/"
  output_path = "${path.module}/zip/lambda_create_auth_challenge.zip"
}

data "archive_file" "python_lambda_verify_auth_package" {
  type        = "zip"
  source_dir  = "${path.module}/../app/verifyauth/"
  output_path = "${path.module}/zip/lambda_verify_auth_challenge.zip"
}