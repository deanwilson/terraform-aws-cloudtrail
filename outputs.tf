output "cloudtrail_log_group_arn" {
  value       = aws_cloudwatch_log_group.cloudtrail.arn
  description = "CloudTrail log group ARN"
}

output "cloudtrail_log_group_name" {
  value       = aws_cloudwatch_log_group.cloudtrail.name
  description = "CloudTrail log group name"
}
