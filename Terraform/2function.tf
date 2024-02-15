data "aws_iam_policy" "example" {
  name = "AmazonAPIGatewayPushToCloudWatchLogs"
}





resource "aws_iam_role" "myapp_lambda_exec" {
  name = "myapp-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.myapp_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "myapp_lambda_policy" {
  role       = aws_iam_role.myapp_lambda_exec.name
  policy_arn = data.aws_iam_policy.example.arn
}


resource "aws_lambda_function" "myapp" {
  function_name = "myapp"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_myapp.key

  runtime = "python3.9"
  handler = "myApp.handler"

  source_code_hash = data.archive_file.lambda_myapp.output_base64sha256

  role = aws_iam_role.myapp_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "myapp" {
  name = "/aws/lambda/${aws_lambda_function.myapp.function_name}"

  retention_in_days = 14
}

data "archive_file" "lambda_myapp" {
  type = "zip"

  source_dir  = "../CloudwatchLoger"
  output_path = "myapp.zip"
}

resource "aws_s3_object" "lambda_myapp" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "myapp.zip"
  source = data.archive_file.lambda_myapp.output_path

  etag = filemd5(data.archive_file.lambda_myapp.output_path)
}
