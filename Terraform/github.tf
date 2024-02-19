resource "github_repository_webhook" "webhook" {
  repository = "Pro"

  configuration {
    url          = "${aws_api_gateway_rest_api.my_api.execution_arn}/${aws_api_gateway_deployment.my_deployment.stage_name}/${aws_api_gateway_resource.my_resource.path_part}"

    content_type = "form"
  }
  events = ["pull_request"]
}