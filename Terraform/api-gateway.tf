/*integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
*/


  integrations = {
    "ANY /" = {
      lambda_arn             = aws_lambda_function.myapp.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }