/*?
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myapp.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/prod/POST/webhook"
}
*/




#good
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "rest_api"
}

#good
resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "webhook" #var.endpoint_path
}
#good
resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "POST" #GET
  authorization = "NONE"
}
#good
resource "aws_api_gateway_integration" "api_integration_lambda" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_resource.id
  http_method = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.myapp.invoke_arn
}
#good
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myapp.function_name #var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.my_api.id}/*/${aws_api_gateway_method.my_method.http_method}${aws_api_gateway_resource.my_resource.path}"
}

resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.my_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.my_method,aws_api_gateway_integration.api_integration_lambda]

}

resource "aws_api_gateway_stage" "my_stage" {
  deployment_id = aws_api_gateway_deployment.my_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = "dev"
}


#________________________________________________________________________
/*

resource "aws_iam_policy" "api_gateway_cloudwatch_logs_policy" {
  name        = "APIGatewayCloudWatchLogsPolicy"
  description = "Allows API Gateway to write logs to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
# Define IAM Role for API Gateway to Write Logs to CloudWatch
resource "aws_iam_role" "api_gateway_execution_role" {
  name               = "APIGatewayExecutionRole"
  assume_role_policy = <<EOF
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
EOF
}


# Attach Policy to Allow API Gateway to Write Logs to CloudWatch
resource "aws_iam_role_policy_attachment" "api_gateway_logs_policy_attachment" {
  role       = aws_iam_role.api_gateway_execution_role.name
  policy_arn = aws_iam_policy.api_gateway_cloudwatch_logs_policy.arn
}

resource "aws_cloudwatch_log_group" "cloudwatch_api" {
  name = "/aws/api/${aws_api_gateway_rest_api.my_api.name}"

  retention_in_days = 14
}

# Define the API Gateway Stage
resource "aws_api_gateway_stage" "stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  deployment_id = aws_api_gateway_deployment.my_deployment.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"method\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"responseLength\":$context.responseLength,\"requestTime\":\"$context.requestTime\",\"responseTime\":\"$context.responseTime\"}"
  }
}

# Define the CloudWatch Log Group
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name = "/aws/api-gateway/${aws_api_gateway_rest_api.my_api.name}"
}
*/








