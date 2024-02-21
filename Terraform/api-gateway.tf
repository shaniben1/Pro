resource "aws_api_gateway_rest_api" "github_webhook_api" {
  name = "github-webhook-api"
  description = "My REST API"
}

resource "aws_api_gateway_resource" "github_webhook_resource" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook_api.id
  parent_id   = aws_api_gateway_rest_api.github_webhook_api.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_method" "github_webhook_method" {
  rest_api_id   = aws_api_gateway_rest_api.github_webhook_api.id
  resource_id   = aws_api_gateway_resource.github_webhook_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myapp.arn
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.github_webhook_api.execution_arn}/*/*/webhook/POST"
}

resource "aws_api_gateway_integration" "github_webhook_integration" {
  rest_api_id             = aws_api_gateway_rest_api.github_webhook_api.id
  resource_id             = aws_api_gateway_resource.github_webhook_resource.id
  http_method             = aws_api_gateway_method.github_webhook_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.myapp.invoke_arn
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "github_webhook_api_deployment"
{
  depends_on = [aws_api_gateway_integration.github_webhook_integration]

  rest_api_id = aws_api_gateway_rest_api.github_webhook_api.id
  stage_name  = "prod"
}


#___________________________________________________________________



# ...

resource "aws_api_gateway_usage_plan" "myusageplan" {
  name = "my_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.github_webhook_api.id
    stage  = aws_api_gateway_deployment.github_webhook_api_deployment.stage_name
  }
}

resource "aws_api_gateway_api_key" "mykey" {
  name = "my_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.mykey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
}



































output "hello_base_url" {
  value = aws_api_gateway_deployment.github_webhook_api_deployment.invoke_url
}


