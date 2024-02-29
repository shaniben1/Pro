resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = "${aws_api_gateway_stage.my_stage.invoke_url}/webhook"
    insecure_ssl = false
    content_type = "json"

  }
  events = ["pull_request"]
}

