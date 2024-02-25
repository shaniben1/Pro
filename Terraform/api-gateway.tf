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
