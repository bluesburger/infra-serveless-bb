variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "regiao da conta aws"
}

variable "lambda_name_signup" {
  type        = string
  default     = "faas-lambda-auto-confirm-user"
  description = "nome da lambda pre signup"
}

variable "lambda_name_define" {
  type        = string
  default     = "faas-lambda-define-auth-challenge"
  description = "nome da lambda pre define"
}

variable "lambda_name_create" {
  type        = string
  default     = "faas-lambda-create-auth-challenge"
  description = "nome da lambda pre create"
}

variable "lambda_name_verify" {
  type        = string
  default     = "faas-lambda-verify-auth-challenge"
  description = "nome da lambda pre verify"
}