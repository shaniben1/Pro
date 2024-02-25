resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = "https://cawl94idt3.execute-api.us-east-1.amazonaws.com/dev/webhook"
    insecure_ssl = false
    content_type = "json"

  }
  events = ["pull_request"]
}