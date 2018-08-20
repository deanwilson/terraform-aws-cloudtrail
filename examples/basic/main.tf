provider "aws" {
  region = "eu-west-1"
}

module "cloudtrail" {
  source = "deanwilson/cloudtrail"

  # create all the resources with "testy" in their name
  # for easier grouping
  namespace = "testy"
}
