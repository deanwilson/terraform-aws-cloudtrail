## Locals

locals {
  default_tags = {
    "Terraform"        = "true"
    "Terraform-Module" = "deanwilson-cloudtrail"
  }

  bucketname = "${var.namespace}-${var.bucketname}"
}

## Resources

### IAM

data "template_file" "cloudtrail_s3_policy_template" {
  template = file("${path.module}/policies/cloudtrail_s3_policy.tpl")

  vars = {
    bucket_name = "${local.bucketname}"
  }
}

### Implementation

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.namespace}-${var.cloudwatch_log_group_name}"
  retention_in_days = var.cloudtrail_log_retention

  tags = merge(
    local.default_tags,
    var.additional_tags
  )
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = local.bucketname
  acl    = "private"
  policy = data.template_file.cloudtrail_s3_policy_template.rendered

  tags = merge(
    local.default_tags,
    var.additional_tags,
    map("Name", local.bucketname)
  )
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs_role" {
  name               = "${var.namespace}-cloudtrail-cloudwatch-logs"
  path               = "/"
  assume_role_policy = file("${path.module}/policies/cloudtrail_assume_policy.json")
}

data "template_file" "cloudtrail_cloudwatch_logs_policy_template" {
  template = file("${path.module}/policies/cloudtrail_cloudwatch_logs_policy.tpl")

  vars = {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cloudtrail.arn
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs_policy" {
  name   = "${var.namespace}-cloudtrail-cloudwatch-logs"
  path   = "/"
  policy = data.template_file.cloudtrail_cloudwatch_logs_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.cloudtrail_cloudwatch_logs_role.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs_policy.arn
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.namespace}-${var.cloudtrail_name}"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cloudwatch_logs_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  enable_log_file_validation    = true
}
