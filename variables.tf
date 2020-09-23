variable "additional_tags" {
  default     = {}
  description = "The tags to apply to resources created by this module"
  type        = map
}

variable "bucketname" {
  default     = "cloudtrail"
  description = "S3 bucketname to store cloudtrail events in"
}

variable "cloudtrail_log_retention" {
  default     = "90"
  description = "Number of days to retain cloudtrail logs"
}

variable "cloudtrail_name" {
  default     = "cloudtrail-all"
  description = "CloudTrail name. Combined with namespace to make it unique"
}

variable "cloudwatch_log_group_name" {
  default     = "cloudtrail/logs"
  description = "Cloudwatch log group name to send Cloudtrail events to"
}

variable "namespace" {
  default     = "cloudtrail"
  description = "An identifier used to group all resources created by this module"
}
