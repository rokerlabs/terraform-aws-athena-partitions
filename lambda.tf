resource "null_resource" "this" {
  triggers = {
    version = var.release
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.package_file} https://github.com/rokerlabs/terraform-aws-athena-partitions/releases/download/${var.release}/athena-partitions.zip"
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.20.0"

  function_name = local.name
  handler       = "athena-partitions"
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

  depends_on = [null_resource.this]
}
