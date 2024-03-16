data "aws_caller_identity" "current" {}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_dir  = "../app/"
  output_path = "../src/app.zip"
}