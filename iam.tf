resource "aws_iam_policy" "this" {
  name   = "${local.name}-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.this.json

  tags = merge(var.tags, {
    Name = "${local.name}-${data.aws_region.current.name}"
  })
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${var.query_result_location == null ? "${aws_s3_bucket.this[0].arn}/*" : replace(var.query_result_location, "s3://", "arn:aws:s3:::")}*"]
  }

  statement {
    actions = ["s3:GetObject"]
    resources = [for partition in var.partitions :
      "${replace(partition.location, "s3://", "arn:aws:s3:::")}*"
    ]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = [for partition in var.partitions :
      "arn:aws:s3:::${regex("s3:\\/\\/([a-z0-9-\\.]+)\\/.*", partition.location)}"
    ]
  }

  statement {
    actions = [
      "glue:BatchCreatePartition",
      "glue:GetDatabase",
      "glue:GetTable",
    ]
    resources = concat(
      ["arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog"],
      [for partition in var.partitions :
        "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${partition.database}"
      ],
      [for partition in var.partitions :
        "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${partition.database}/${partition.table}"
      ]
    )
  }

  statement {
    actions   = ["athena:StartQueryExecution"]
    resources = ["arn:aws:athena:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:workgroup/*"]
  }
}
