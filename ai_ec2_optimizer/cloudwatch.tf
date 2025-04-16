resource "aws_cloudwatch_event_rule" "scheduled_rule" {
  name        = "scheduled_rule"
  description = "Triggers the Lambda function every day at midnight"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "scheduled_lambda_target" {
  rule      = aws_cloudwatch_event_rule.scheduled_rule.name
  arn       = aws_lambda_function.ai_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ai_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_rule.arn
}
