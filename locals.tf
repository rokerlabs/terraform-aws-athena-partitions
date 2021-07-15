locals {
  package_file = "${local.name}-${var.release}.zip"
  package_url  = "https://github.com/rokerlabs/terraform-aws-athena-partitions/releases/download/${var.release}/athena-partitions.zip"
  databases = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${partition.database}"
  ])
  extra_event_inputs = {
    query_result_location = var.query_result == null ? "s3://${aws_s3_bucket.this[0].bucket}/" : var.query_result.location
  }
  name                      = "${var.name}-athena-partitions"
  query_result_location_arn = var.query_result == null ? aws_s3_bucket.this[0].arn : var.query_result.bucket_arn
  tables = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${partition.database}/${partition.table}"
  ])
}