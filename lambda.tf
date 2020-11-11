
data "archive_file" "zipit" {
  type = "zip"
  source_dir = "lambda"
  output_path = "/tmp/aws-cloud-manager.zip"
}

resource "aws_lambda_function" "example" {
  filename = data.archive_file.zipit.output_path
  source_code_hash = data.archive_file.zipit.output_base64sha256
  function_name = "alexa-cloud-manager"
  handler = "main.handler"
  runtime = "python3.8"
  role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_alexa_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

