resource "aws_lambda_function" "lambda_authorizer" {
  function_name = var.function_name
  filename      = "../app"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  depends_on    = [aws_cognito_user_pool.my_user_pool]
  environment {
    variables = {
      user_pool_id = aws_cognito_user_pool.my_user_pool.id
      aws_region   = var.aws_region
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-authorizer-bb-role"
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
