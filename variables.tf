variable "name" {
  type        = string
  description = "Identifier for the group of logs to be partitioned"
}

variable "partitions" {
  type = map(object({
    database = string
    table    = string
    location = string
  }))
  description = "Map of Athena partitions to be managed"
}

variable "query_result" {
  type = object({
    bucket_arn = string
    location   = string
  })
  default     = null
  description = "Specify the S3 bucket query result location"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS resource tags"
}