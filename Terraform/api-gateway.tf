resource "aws_apigatewayv2_api" "my_api" {
  name          = "my-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "my_lambda_integration" {
  api_id           = aws_apigatewayv2_api.my_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.myapp.invoke_arn
}

resource "aws_apigatewayv2_route" "my_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "POST /webhook"
  target    = "integrations/${aws_apigatewayv2_integration.my_lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myapp.function_name
  principal     = "apigateway.amazonaws.com"

  // This source arn restricts API Gateway to invoke only the specified route
  source_arn = "${aws_apigatewayv2_api.my_api.execution_arn}/*/*"
}

// Optionally, create a deployment if you need to invoke a specific deployment rather than auto-deploy
resource "aws_apigatewayv2_deployment" "my_deployment" {
  api_id = aws_apigatewayv2_api.my_api.id

  // Forces a new deployment if the routes change
  triggers = {
    redeployment = sha1(jsonencode(aws_apigatewayv2_route.my_route))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_apigatewayv2_route.my_route,
  ]
}

// Reference the deployment in the stage if you created one
resource "aws_apigatewayv2_stage" "my_stage" {
  api_id        = aws_apigatewayv2_api.my_api.id
  name          = "default"
  deployment_id = aws_apigatewayv2_deployment.my_deployment.id
}
