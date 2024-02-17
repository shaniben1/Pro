
resource "github_repository_webhook" "example" {
  repository = "YOUR_REPOSITORY"
  name       = "Pro"
  events     = ["push"]
  active     = true
  configuration {
    url          = "https://github.com/shaniben1/Pro.git"

  }
}