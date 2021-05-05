# Athena Partitions

[![Build status](https://badge.buildkite.com/14643f8b21c7489e73738e0496588aa1892053221ee1771c06.svg)](https://buildkite.com/rokerlabs/athena-partitions)

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_partitions"></a> [partitions](#input\_partitions) | Map list of Athena partitions to be managed | <pre>tuple(object({<br>    database = string<br>    table    = string<br>    location = object({<br>      bucket = string<br>      key    = string<br>    })<br>    query_result_bucket = string<br>  }))</pre> | <pre>[<br>  {}<br>]</pre> | no |
| <a name="input_release"></a> [release](#input\_release) | Release/version of the Athena Partitions function code e.g. `v0.0.0`. | `string` | `"v0.0.0"` | no |

## Outputs

No outputs.

## Copyright

Copyright (c) 2021 Roker Labs. See [LICENSE](./LICENSE) for details.
