locals {
  package_file = "${local.name}-${var.release}.zip"
  package_url  = "https://github.com/rokerlabs/terraform-aws-athena-partitions/releases/download/${var.release}/athena-partitions.zip"
  databases = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${partition.database}"
  ])
  extra_event_inputs = {
    query_result_location = var.query_result == null ? "s3://${aws_s3_bucket.this[0].bucket}/" : var.query_result.location
  }
  # Lambda config is managed in this local var block to ensure any lambda config change will trigger the artifact to be downloaded
  lambda_config = {
    function_name = local.name
    handler       = local.name
    runtime       = "go1.x"

    create_package         = false
    local_existing_package = local.package_file

    attach_policy = true
    policy        = aws_iam_policy.this.arn

    memory_size = 128

    allowed_triggers = {
      CloudWatchEvent = {
        principal  = "events.amazonaws.com"
        source_arn = aws_cloudwatch_event_rule.this.arn
      }
    }
    # Disable creating trigger permission for published versions, since publish = false.
    create_current_version_allowed_triggers = false

    tags = merge(var.tags, {
      Name = local.name
    })
  }
  name                      = "${var.name}-athena-partitions"
  query_result_location_arn = var.query_result == null ? aws_s3_bucket.this[0].arn : var.query_result.bucket_arn
  tables = distinct([for partition in var.partitions :
    "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${partition.database}/${partition.table}"
  ])
}