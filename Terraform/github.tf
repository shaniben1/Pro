resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = aws_api_gateway_deployment.my_deployment.invoke_url
    insecure_ssl = false
    content_type = "json"

  }
  events = ["pull_request"]
}