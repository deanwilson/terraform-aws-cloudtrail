## Locals

locals {
  default_tags = {
    "Terraform"        = "true"
    "Terraform-Module" = "deanwilson-cloudtrail"
  }

  bucketname = "${var.namespace}-${var.bucketname}"
}

## Data

data "aws_iam_policy_document" "bucket" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.bucketname}"]
  }

  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucketname}/*"]

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    sid = ""

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"
    actions = ["logs:CreateLogStream"]
    resources = [aws_cloudwatch_log_group.cloudtrail.arn]
  }

  statement {
    effect = "Allow"
    actions = ["logs:PutLogEvents"]
    resources = [aws_cloudwatch_log_group.cloudtrail.arn]
  }
}

## Resources

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

  tags = merge(
    local.default_tags,
    var.additional_tags,
    tomap({ "Name" = local.bucketname })
  )
}

resource "aws_s3_bucket_policy" "cloudtrail_s3_policy" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.bucket.json
}

resource "aws_s3_bucket_acl" "cloudtrail_acl" {
  bucket = aws_s3_bucket.cloudtrail.id
  acl    = "private"
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs_role" {
  name               = "${var.namespace}-cloudtrail-cloudwatch-logs"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs_policy" {
  name = "${var.namespace}-cloudtrail-cloudwatch-logs"
  path = "/"
  policy = data.aws_iam_policy_document.logs.json
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
