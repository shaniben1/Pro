resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = "https://quhvwdej85.execute-api.us-east-1.amazonaws.com/dev/webhook"
    #url = aws_lambda_permission.api_gw.source_arn
    insecure_ssl = false
    content_type = "json"

  }
  events = ["pull_request"]

}

