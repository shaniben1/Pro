module "apigateway_v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "3.1.0"


  name          = "dev-http"
  description   = "Shani HTTP API Gateway"
  protocol_type = "HTTP"

  create_api_domain_name = false


  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = aws_lambda_function.myapp.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }


  tags = {
    Name = "http-apigateway"
  }

}


