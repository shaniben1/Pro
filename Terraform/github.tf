
resource "github_repository" "repo" {
  name         = "Pro"

}

resource "github_repository_webhook" "foo" {
  repository = github_repository.repo.name

  configuration {
    url          = module.apigateway_v2.apigatewayv2_api_api_endpoint
    content_type = "json"
  }

  events = ["pull_requests"]
}