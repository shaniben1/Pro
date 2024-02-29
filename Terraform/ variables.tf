variable "github_token" {
  description = "github token"
  type = string
}

variable "accountId" {
  description = "the AWS accountId"
  type = string
}

variable "myregion" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  description = "lambda function name"
  type = string
  default = "myapp"
}

variable "endpoint_path" {
  description = "the post endpoint path"
  type        = string
  default     = "webhook"
}

