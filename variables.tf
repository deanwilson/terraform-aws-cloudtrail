variable "additional_tags" {
  default     = {}
  description = "The tags to apply to resources created by this module"
  type        = "map"
}

variable "bucketname" {
  default     = "cloudtrail"
  description = "S3 bucketname to store cloudtrail events in"
  type        = "string"
}

variable "cloudtrail_log_retention" {
  default     = "90"
  description = "Number of days to retain cloudtrail logs"
  type        = "string"
}

variable "cloudtrail_name" {
  default     = "cloudtrail-all"
  description = "CloudTrail name. Combined with namespace to make it unique"
  type        = "string"
}

variable "cloudwatch_log_group_name" {
  default     = "cloudtrail/logs"
  description = "Cloudwatch log group name to send Cloudtrail events to"
  type        = "string"
}

variable "namespace" {
  default     = "cloudtrail"
  description = "An identifier used to group all resources created by this module"
  type        = "string"
}
