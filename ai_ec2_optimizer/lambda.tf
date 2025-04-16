resource "aws_lambda_function" "ai_lambda" {
  function_name = "ai_ec2_optimizer_lambda"
  role          = aws_iam_role.lambda_execution_role.arn  # Ensure this role is declared

  handler = "lambda_function.lambda_handler"  # This is the entry point function
  runtime = "python3.9"  # Adjust the runtime if you use another version

  # The path to the zip file containing your Lambda function
  filename = "lambda_function.zip"  # Ensure this points to your zip file

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.my_bucket.bucket
    }
  }
}
