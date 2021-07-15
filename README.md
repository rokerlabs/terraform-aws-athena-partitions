# Athena Partitions

[![Latest Release](https://img.shields.io/github/release/rokerlabs/terraform-aws-athena-partitions.svg)](./releases/latest) [![Build status](https://badge.buildkite.com/14643f8b21c7489e73738e0496588aa1892053221ee1771c06.svg?branch=master)](https://buildkite.com/rokerlabs/athena-partitions) [![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

[Developer Documentation](https://rokerlabs.github.io/terraform-aws-athena-partitions/)

Add partitions to Athena tables with a scheduled Lambda function.

Why does this project exist? See the AWS documentation for [Partitioning Data - Scenario 2: Data is not partitioned in Hive format](https://docs.aws.amazon.com/athena/latest/ug/partitions.html) in [Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) for ELB/ALB Logs (Classic and Application Load Balancers).

Athena partitions will alow you run queries against specific dates, reducing query cost and execution time. Example logs query using date partitions:
```SQL
SELECT elb_status_code, request_url
FROM alb_logs
WHERE elb_status_code != '200' AND
  (
    year = '2021' AND
    month = '05' AND
    day = '04'
  )
LIMIT 10;
```

### Architecture

This Terraform module creates a scheduled Lambda function, adding daily partitions for each log location specified in the `partitions` input configuration block.

![Athena Partitions Architecture](https://raw.githubusercontent.com/rokerlabs/terraform-aws-athena-partitions/master/docs/assets/architecture.png)

### Prerequisites

The Athena table for Elastic Load Balancing logs needs to be created/altered to include the partitions for _**year**_, _**month**_, and _**day**_. Copy and paste the following snippet into the [Athena console](https://console.aws.amazon.com/athena/home), substituting for `LOG_BUCKET`, `LOGS_PREFIX`, `AWS_ACCOUNT_ID`, and `AWS_REGION`.

#### Classic Load Balancer

```HiveQL
CREATE EXTERNAL TABLE IF NOT EXISTS elb_logs (
  request_timestamp string,
  elb_name string,
  request_ip string,
  request_port int,
  backend_ip string,
  backend_port int,
  request_processing_time double,
  backend_processing_time double,
  client_response_time double,
  elb_response_code string,
  backend_response_code string,
  received_bytes bigint,
  sent_bytes bigint,
  request_verb string,
  url string,
  protocol string,
  user_agent string,
  ssl_cipher string,
  ssl_protocol string
)
PARTITIONED BY(year string, month string, day string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
 'serialization.format' = '1',
 'input.regex' = '([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:\-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \\\"([^ ]*) ([^ ]*) (- |[^ ]*)\\\" (\"[^\"]*\") ([A-Z0-9-]+) ([A-Za-z0-9.-]*)$' )
LOCATION 's3://LOG_BUCKET/LOGS_PREFIX/AWSLogs/AWS_ACCOUNT_ID/elasticloadbalancing/AWS_REGION/';
```

#### Application Load Balancer

```HiveQL
CREATE EXTERNAL TABLE IF NOT EXISTS alb_logs (
  type string,
  time string,
  elb string,
  client_ip string,
  client_port int,
  target_ip string,
  target_port int,
  request_processing_time double,
  target_processing_time double,
  response_processing_time double,
  elb_status_code string,
  target_status_code string,
  received_bytes bigint,
  sent_bytes bigint,
  request_verb string,
  request_url string,
  request_proto string,
  user_agent string,
  ssl_cipher string,
  ssl_protocol string,
  target_group_arn string,
  trace_id string,
  domain_name string,
  chosen_cert_arn string,
  matched_rule_priority string,
  request_creation_time string,
  actions_executed string,
  redirect_url string,
  error_reason string
)
PARTITIONED BY(year string, month string, day string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
'serialization.format' = '1',
'input.regex' =
'([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^ ]*)\" \"([^ ]*)\"' )
LOCATION 's3://LOG_BUCKET/LOGS_PREFIX/AWSLogs/AWS_ACCOUNT_ID/elasticloadbalancing/AWS_REGION/';
```

## Usage

General use case example:

```hcl
module "athena_partitions" {
  source  = "rokerlabs/athena-partitions/aws"
  version = "~> 1.0.0"

  name = "alb-logs"

  partitions = {
    my_alb_logs = {
      database = "production"
      table    = "alb_logs"
      location = "s3://logs-123456789000-us-west-2/AWSLogs/123456789000/elasticloadbalancing/us-west-2/"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
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
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | 2.7.0 |

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
| <a name="input_name"></a> [name](#input\_name) | Identifier for the group of logs to be partitioned | `string` | n/a | yes |
| <a name="input_partitions"></a> [partitions](#input\_partitions) | Map of Athena partitions to be managed | <pre>map(object({<br>    database = string<br>    table    = string<br>    location = string<br>  }))</pre> | n/a | yes |
| <a name="input_query_result"></a> [query\_result](#input\_query\_result) | Specify the S3 bucket query result location | <pre>object({<br>    bucket_arn = string<br>    location   = string<br>  })</pre> | `null` | no |
| <a name="input_release"></a> [release](#input\_release) | Release/version of the Athena Partitions function code e.g. `v0.0.0`. | `string` | `"v1.0.0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS resource tags | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Copyright

Copyright (c) 2021 Roker Labs. See [LICENSE](./LICENSE) for details.