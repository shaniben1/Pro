
/*
resource "aws_api_gateway_account" "example" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_role.arn
}

resource "aws_iam_role" "api_gateway_role" {
  name = "api_gateway_logs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  # Add policies as necessary
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_stage" "example" {
  stage_name = "example"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # Enable CloudWatch logging for the stage
  logging_config {
    level   = "INFO"
    metrics_enabled = true
    data_trace_enabled = true
    logging_level = "INFO"
    destination_arn = aws_cloudwatch_log_group.example.arn
  }
  deployment_id = aws_api_gateway_deployment.github_webhook_api_deployment.id
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/api-gateway/example"
  retention_in_days = 7 # Adjust retention period as needed
}
*/
#_______________________________________________________


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
/*
variable "stage_name" {
  default = "shani"
  type    = string
}
resource "aws_api_gateway_stage" "example" {
  depends_on = [aws_cloudwatch_log_group.example]

  stage_name = var.stage_name
  # ... other configuration ...
  deployment_id = aws_api_gateway_deployment.github_webhook_api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.rest_api.id}/${var.stage_name}"
  retention_in_days = 7
  # ... potentially other configuration ...
}
*/





resource "aws_api_gateway_stage" "example" {
  stage_name    = "test"
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  deployment_id = aws_api_gateway_deployment.github_webhook_api_deployment.id

  logging_config {
    destination_arn = aws_cloudwatch_log_group.example.arn
    level           = "INFO"
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/aws/api-gateway/example-api"
}





