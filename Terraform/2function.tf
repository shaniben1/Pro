
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

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


resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  description = "IAM policy for logging from a lambda"
  path = "/"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_lambda_function" "myapp" {
  function_name = "myapp" #var.lambda_function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id

  s3_key    = aws_s3_object.lambda_myapp.key

  runtime          = "python3.9"
  handler          = "myapp.handler"
  source_code_hash = data.archive_file.lambda_myapp_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
}


data "archive_file" "lambda_myapp_zip" {
  type = "zip"

  source_dir  = "../CloudwatchLoger"
  output_path = "myapp.zip"
}



resource "aws_s3_object" "lambda_myapp" {

  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "myapp.zip"
  source = data.archive_file.lambda_myapp_zip.output_path

  etag = filemd5(data.archive_file.lambda_myapp_zip.output_path)
}


resource "aws_cloudwatch_log_group" "cloudwatch_myapp" {
  name = "/aws/lambda/${aws_lambda_function.myapp.function_name}"

  retention_in_days = 14
}




