# Cloudtrail Terraform Module

Configure CloudTrail to send events to an S3 bucket and CloudWatch log group

## Usage

The simplest use case, with nearly all defaults.

    provider "aws" {
      region = "eu-west-1"
    }

    module "cloudtrail" {
      source    = "deanwilson/cloudtrail"
      namespace = "testy"
    }

This creates an S3 bucket and CloudWatch log group, with `testy` as a prefix to
help reduce naming conflicts, and adds all the required policies to permit
CloudTrail events to be sent to them.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_tags | The tags to apply to resources created by this module | map | `<map>` | no |
| bucketname | S3 bucketname to store cloudtrail events in | string | `cloudtrail` | no |
| cloudtrail_log_retention | Number of days to retain cloudtrail logs | string | `90` | no |
| cloudtrail_name | CloudTrail name. Combined with namespace to make it unique | string | `cloudtrail-all` | no |
| cloudwatch_log_group_name | Cloudwatch log group name to send Cloudtrail events to | string | `cloudtrail/logs` | no |
| namespace | An identifier used to group all resources created by this module | string | `cloudtrail` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudtrail_log_group_arn | CloudTrail log group ARN |
| cloudtrail_log_group_name | CloudTrail log group name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Author

[Dean Wilson](https://www.unixdaemon.net)

### License

This module is released under the Mozilla Public License 2.0, the
same license as Terraform itself.
