variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "regiao da conta aws"
}

variable "lambda_name_signup" {
  type        = string
  default     = "lambda_auto_confirm_user"
  description = "nome da lambda pre signup"
}

variable "lambda_name_define" {
  type        = string
  default     = "lambda_define_auth_challenge"
  description = "nome da lambda pre define"
}

variable "lambda_name_create" {
  type        = string
  default     = "lambda_create_auth_challenge"
  description = "nome da lambda pre create"
}

variable "lambda_name_verify" {
  type        = string
  default     = "lambda_verify_auth_challenge"
  description = "nome da lambda pre verify"
}