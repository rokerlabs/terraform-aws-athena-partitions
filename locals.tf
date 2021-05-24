locals {
  package_file = "${local.name}-${var.release}.zip"
  package_url  = "https://github.com/rokerlabs/terraform-aws-athena-partitions/releases/download/${var.release}/${local.name}.zip"
  databases = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${partition.database}"
  ])
  extra_event_inputs = {
    query_result_location = "s3://${aws_s3_bucket.this.bucket}/"
  }
  name = "${var.name}-athena-partitions"
  tables = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${partition.database}/${partition.table}"
  ])
}