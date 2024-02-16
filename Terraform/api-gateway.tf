

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "dev-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"


  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = aws_lambda_function.myapp.role
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }


    "$default" = {
      lambda_arn = aws_lambda_function.myapp.role
    }
  }


  tags = {
    Name = "http-apigateway"
  }
}