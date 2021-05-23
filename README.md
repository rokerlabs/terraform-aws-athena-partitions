# Athena Partitions

[![Latest Release](https://img.shields.io/github/release/rokerlabs/terraform-aws-athena-partitions.svg)](./releases/latest) [![Build status](https://badge.buildkite.com/14643f8b21c7489e73738e0496588aa1892053221ee1771c06.svg)](https://buildkite.com/rokerlabs/athena-partitions)

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

[Developer Documentation](https://rokerlabs.github.io/terraform-aws-athena-partitions/)

## Usage

General use case examples and recommendations.

```hcl
module "athena_partition" {
  source  = "rokerlabs/athena-partition/aws"
  version = "~> 0.0.0"

  partitions = [{
    database = "production"
    table    = "alb_logs"
    location = {
      bucket = "logs-123456789000-us-west-2"
      key    = "AWSLogs/123456789000/elasticloadbalancing/us-west-2/"
    }
    query_result_bucket = "aws-athena-query-results-123456789000-us-west-2"
  }]
}
```

---
<!-- generated-docs-below -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws |  |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_partitions"></a> [partitions](#input\_partitions) | Map list of Athena partitions to be managed | <pre>list(object({<br>    database = string<br>    table    = string<br>    location = string<br>  }))</pre> | n/a | yes |
| <a name="input_release"></a> [release](#input\_release) | Release/version of the Athena Partitions function code e.g. `v0.0.0`. | `string` | `"v0.0.0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS resource tags | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Copyright

Copyright (c) 2021 Roker Labs. See [LICENSE](./LICENSE) for details.
