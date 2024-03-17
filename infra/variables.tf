variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "regiao da conta aws"
}

variable "function_name" {
  type        = string
  default     = "lambda-pre-authentication-bb"
  description = "nome da lambda de pre autenticacao do cognito autorizer"
}
