
    integrations = {
    "ANY /" = {
      lambda_arn             = module.aws_lambda_function.myapp.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }









