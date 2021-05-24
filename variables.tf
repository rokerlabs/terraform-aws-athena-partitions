variable "name" {
  type        = string
  description = "Identifier for the group of logs to be partitioned"
}

variable "partitions" {
  type = list(object({
    database = string
    table    = string
    location = string
  }))
  description = "Map list of Athena partitions to be managed"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS resource tags"
}