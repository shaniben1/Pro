resource "aws_api_gateway_rest_api" "rest_api" {
  name = "MyAPI"
  #description = "My REST API"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myapp.arn
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}

resource "aws_api_gateway_integration" "github_webhook_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.myapp.invoke_arn

}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "github_webhook_api_deployment" {
  depends_on = [aws_api_gateway_integration.github_webhook_integration]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "dev"
}




variable "stage_name" {
  default = "dev"
  type    = string
}



resource "aws_api_gateway_stage" "example" {
  depends_on = [aws_cloudwatch_log_group.example]

  stage_name = var.stage_name
  deployment_id = aws_api_gateway_deployment.github_webhook_api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  destination_arn = aws_cloudwatch_log_group.example.arn

}



resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/api-gateway/shani-api"
  retention_in_days = 7
}

