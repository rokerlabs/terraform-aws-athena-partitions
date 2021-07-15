partitions = {
  alb_logs = {
    database = "test"
    table    = "alb_logs"
    location = "s3://logs-012345678900/AWSLogs/012345678900/elasticloadbalancing/us-east-1/"
  }
}

query_result_location = "s3://aws-athena-query-results-012345678900-us-east-1/athena-partitions/"

tags = {
  Service = "athena-partitions"
}