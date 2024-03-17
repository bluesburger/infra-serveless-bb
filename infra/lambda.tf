resource "aws_lambda_function" "lambda_pre_authentication" {
  function_name    = var.function_name
  filename         = data.archive_file.python_lambda_package.output_path
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  handler          = "lambda_pre_authentication_service.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}" #
  retention_in_days = 1
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-pre-authentication-bb-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cognito_policy_attachment" {
  name       = "cognito-policy-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

resource "aws_iam_policy" "lambda_cloudwatch_logs_policy" {
  name        = "lambda-cloudwatch-logs-policy"
  description = "Permite que a função Lambda escreva em logs do CloudWatch"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_cloudwatch_logs_attachment" {
  name       = "lambda-cloudwatch-logs-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_cloudwatch_logs_policy.arn
}
