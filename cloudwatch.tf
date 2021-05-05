resource "aws_cloudwatch_event_rule" "this" {
  name                = "athena-partitions"
  description         = "Daily trigger for the Athena Partitions Lambda function."
  schedule_expression = "rate(1 day)"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  arn   = module.lambda.lambda_function_arn
  input = tostring(jsonencode(var.partitions))
  rule  = aws_cloudwatch_event_rule.this.name
}
