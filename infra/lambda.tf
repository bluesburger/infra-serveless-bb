resource "aws_lambda_function" "lambda_verify_auth_challenge" {
  function_name    = var.lambda_name_verify
  filename         = data.archive_file.python_lambda_verify_auth_package.output_path
  source_code_hash = data.archive_file.python_lambda_verify_auth_package.output_base64sha256
  handler          = "lambda_verify_auth_challenge.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_lambda_function" "lambda_create_auth_challenge" {
  function_name    = var.lambda_name_create
  filename         = data.archive_file.python_lambda_create_auth_package.output_path
  source_code_hash = data.archive_file.python_lambda_create_auth_package.output_base64sha256
  handler          = "lambda_create_auth_challenge.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_lambda_function" "lambda_define_auth_challenge" {
  function_name    = var.lambda_name_define
  filename         = data.archive_file.python_lambda_define_auth_package.output_path
  source_code_hash = data.archive_file.python_lambda_define_auth_package.output_base64sha256
  handler          = "lambda_define_auth_challenge.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_lambda_function" "lambda_auto_confirm_user" {
  function_name    = var.lambda_name_signup
  filename         = data.archive_file.python_lambda_pre_signup_package.output_path
  source_code_hash = data.archive_file.python_lambda_pre_signup_package.output_base64sha256
  handler          = "lambda_auto_confirm_user.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_role.arn
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_create_logs" {
  name              = "/aws/lambda/${var.lambda_name_create}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "lambda_define_logs" {
  name              = "/aws/lambda/${var.lambda_name_define}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "lambda_verify_logs" {
  name              = "/aws/lambda/${var.lambda_name_verify}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "lambda_signup_logs" {
  name              = "/aws/lambda/${var.lambda_name_signup}"
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
      },
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_cloudwatch_logs_policy" {
  name        = "lambda-cloudwatch-logs-policy"
  description = "Permite que a função Lambda escreva em logs do CloudWatch"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_cloudwatch_logs_attachment" {
  name       = "lambda-cloudwatch-logs-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_cloudwatch_logs_policy.arn
}

resource "aws_iam_policy_attachment" "cognito_policy_attachment" {
  name       = "cognito-policy-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.cognito-triggers.arn
}

# Permissão para Cognito invocar Função Lambda 1
resource "aws_lambda_permission" "permissao_lambda_1" {
  statement_id  = "AllowCognitoToInvokeLambda1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_auto_confirm_user.arn
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:${var.aws_region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.my_user_pool.id}"
}