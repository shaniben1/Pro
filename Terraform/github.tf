
resource "github_repository" "repo" {
  name         = "Pro"
  description  = "Terraform acceptance tests"


  visibility   = "public"
}

resource "github_repository_webhook" "foo" {
  repository = github_repository.repo.name

  configuration {
    url          = "https://github.com/shaniben1/Pro.git/"
    content_type = "form"
    insecure_ssl = false
  }

  active = false

  events = ["issues"]
}