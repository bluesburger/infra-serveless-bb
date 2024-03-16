data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  output_path = "../src/app.zip"
  source_dir  = "../app/"
}