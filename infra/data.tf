data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_package" {
  type = "zip"
  source_file = "${path.module}../src/app"
  output_path = "../src/app.zip"
}