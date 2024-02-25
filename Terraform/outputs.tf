output "endpoint_url" {
  value = "${aws_api_gateway_stage.my_stage.invoke_url}/${var.endpoint_path}"
}



output "endpoint_url_deployment" {
  value = "${aws_api_gateway_deployment.my_deployment.invoke_url}/${var.endpoint_path}"
}


