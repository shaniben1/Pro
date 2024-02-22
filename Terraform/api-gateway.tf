resource "aws_iam_role" "myapp_rest_api_exec" {
  name = "myapp-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}







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
  #source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/webhook/POST"
}

resource "aws_api_gateway_integration" "github_webhook_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  type                    = "AWS"
  uri                     = aws_lambda_function.myapp.invoke_arn
  credentials: null
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "github_webhook_api_deployment"
{
  depends_on = [aws_api_gateway_integration.github_webhook_integration]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "prod"
}






output "hello_base_url" {
  value = aws_api_gateway_deployment.github_webhook_api_deployment.invoke_url
}


