resource "null_resource" "this" {
  triggers = {
    artifact       = local.package_file
    config         = local.lambda_config
    module_version = "2.7.0"
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.package_file} ${local.package_url}"
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.7.0"

  function_name                           = local.lambda_config.function_name
  handler                                 = local.lambda_config.handler
  runtime                                 = local.lambda_config.runtime
  create_package                          = local.lambda_config.create_package
  local_existing_package                  = local.lambda_config.local_existing_package
  attach_policy                           = local.lambda_config.attach_policy
  policy                                  = local.lambda_config.policy
  memory_size                             = local.lambda_config.memory_size
  allowed_triggers                        = local.lambda_config.allowed_triggers
  create_current_version_allowed_triggers = local.lambda_config.create_current_version_allowed_triggers
  tags                                    = local.lambda_config.tags

  depends_on = [null_resource.this]
}
