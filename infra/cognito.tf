resource "aws_cognito_user_pool" "my_user_pool" {
  name = "blues-burger-user-pool"

  lambda_config {
    define_auth_challenge          = local.lambda_name_define_arn
    create_auth_challenge          = local.lambda_name_create_arn
    verify_auth_challenge_response = local.lambda_name_verify_arn
    pre_sign_up                    = local.lambda_name_signup_arn
  }

  schema {
    name                = "cpf"
    attribute_data_type = "String"
  }
}

resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name         = "blues-burger-app-client"
  user_pool_id = aws_cognito_user_pool.my_user_pool.id
}

resource "aws_iam_policy" "cognito-triggers" {
  name        = "cognito-triggers-policy"
  description = "Permite que o cognito trigge as lambdas"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "cognito-idp:*",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceAccount" : data.aws_caller_identity.current.account_id
          },
          "ArnLike" : {
            "AWS:SourceArn" : "arn:aws:cognito-idp:${var.aws_region}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.my_user_pool.id}"
          }
        }
      }
    ]
  })
}