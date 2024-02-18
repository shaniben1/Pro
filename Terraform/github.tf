
resource "github_repository" "repo" {
  name         = "Pro"
  description  = "Shani_repo"
  visibility   = "public"
}

resource "github_repository_webhook" "foo" {
  repository = github_repository.repo.name

  configuration {
    url          = "https://github.com/shaniben1/Pro.git/"
    content_type = "json"
  }

  active = false

  events = ["push"]
}