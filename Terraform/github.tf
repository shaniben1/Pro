/*
resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = aws_apigatewayv2_stage.shani.invoke_url
    insecure_ssl = false
    content_type = "form"
  }
  events = ["pull_request"]
}
*/

resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = aws_api_gateway_deployment.github_webhook_api_deployment.invoke_url
    insecure_ssl = false
    content_type = "form"
  }
  events = ["pull_request"]
}