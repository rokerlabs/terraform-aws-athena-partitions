variable "name" {
  type        = string
  description = "Identifier for the group of logs to be partitioned."
}

variable "partitions" {
  type = map(object({
    database = string
    table    = string
    location = string
  }))
  description = "Map of Athena ALB/ELB log partitions to be managed."
}

variable "query_result_location" {
  type        = string
  default     = null
  description = "Specify an existing (S3 bucket) query result location. If not set, the module will create an S3 bucket for the functions query results."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS resource tags."
}