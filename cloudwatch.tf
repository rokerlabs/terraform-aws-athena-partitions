resource "aws_cloudwatch_event_rule" "this" {
  name                = local.name
  description         = "Daily trigger for the Athena Partitions Lambda function."
  schedule_expression = "rate(1 day)"

  tags = merge(var.tags, {
    Name = local.name
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.partitions

  arn = module.lambda.lambda_function_arn
  input = tostring(jsonencode(merge(each.value, {
    query_result_location = var.query_result_location == null ? "s3://${aws_s3_bucket.this[0].bucket}/" : var.query_result_location
  })))
  rule = aws_cloudwatch_event_rule.this.name
}
