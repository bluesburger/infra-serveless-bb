data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/zip/lambda_authorizer.zip"
}