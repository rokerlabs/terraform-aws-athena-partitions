resource "aws_s3_bucket" "this" {
  count = var.query_result_location == null ? 1 : 0

  bucket = "${local.name}-results-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${local.name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  })

  #checkov:skip=CKV_AWS_18:The bucket does not require access logging
  #checkov:skip=CKV_AWS_21:The bucket does not require object versioning
  #checkov:skip=CKV_AWS_52:The bucket does not require MFA delete protection
  #checkov:skip=CKV_AWS_144:The bucket does not require backup
  #checkov:skip=CKV_AWS_145:The bucket uses server-side encryption instead of KMS
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.query_result_location == null ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}