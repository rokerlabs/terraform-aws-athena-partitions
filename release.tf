variable "release" {
  type        = string
  default     = "v1.0.0"
  description = "Release/version of the Athena Partitions function code e.g. `v0.0.0`."

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^v\\d+\\.\\d+\\.\\d+$", var.release))
    error_message = "The release value must match the semantic versioning format:`v0.0.0`."
  }
}
