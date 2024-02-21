resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = aws_apigatewayv2_stage.shani.invoke_url

    content_type = "form"
  }
  events = ["pull_request"]
}