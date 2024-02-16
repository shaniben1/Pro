

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "dev-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"


  # Access logs ????
  default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"


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