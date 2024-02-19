resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = module.apigateway_v2.apigatewayv2_api_api_endpoint
    content_type = "form"
  }

  active = false

  events = ["pull_request"]
}