locals {
  package_url = "https://github.com/rokerlabs/terraform-aws-athena-partitions/releases/download/${var.release}/${local.name}.zip"
  artifact    = "${local.name}-${var.release}.zip"
}

resource "null_resource" "this" {
  triggers = {
    downloaded = local.artifact
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.artifact} ${local.package_url}"
  }
}

data "null_data_source" "this" {
  inputs = {
    id       = null_resource.this.id
    filename = local.artifact
  }
}

module "lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = local.name
  handler       = local.name
  runtime       = "go1.x"

  create_package         = false
  local_existing_package = data.null_data_source.this.outputs["filename"]

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
