data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  output_path = "${path.module}../src/app.zip"
  source_dir  = "${path.module}../app/"
}