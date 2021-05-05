resource "aws_iam_policy" "this" {
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:*:*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:*:log-group:/aws/lambda/*:*"]
  }

  statement {
    actions   = ["athena:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["glue:CreatePartition"]
    resources = ["*"]
  }
}
