variable "function_name" {
  type = string
  default = "lambda-authorizer-bb"
  description = "nome da lambda authorizer"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "regiao da conta aws"
}
