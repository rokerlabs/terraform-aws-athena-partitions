resource "aws_iam_policy" "this" {
  name   = "${local.name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:/aws/lambda/${local.name}"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.name}:*"]
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }

  statement {
    actions   = ["s3:GetBucketLocation"]
    resources = [aws_s3_bucket.this.arn]
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["*"]
  }

  statement {
    actions = [
      "glue:BatchCreatePartition",
      "glue:GetDatabase",
      "glue:GetTable",
    ]
    resources = ["arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog"]
  }

  statement {
    actions = [
      "glue:BatchCreatePartition",
      "glue:GetDatabase",
    ]
    resources = local.databases
  }

  statement {
    actions = [
      "glue:BatchCreatePartition",
      "glue:GetTable",
    ]
    resources = local.tables
  }

  statement {
    actions   = ["athena:StartQueryExecution"]
    resources = ["arn:aws:athena:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/*"]
  }
}
