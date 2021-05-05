variable "partitions" {
  type        = list(object({
    database              = string
    table                 = string
    location              = string
    query_result_location = string
  }))
  description = "Map list of Athena partitions to be managed"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS resource tags"
}