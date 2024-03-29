data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./boto"
  output_path = "lambda.zip"
}

data "archive_file" "requests" {
  depends_on  = [null_resource.layers]
  type        = "zip"
  source_dir  = "./layers"
  output_path = "requests.zip"
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [var.supporting_resources_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.supporting_resources_name}*.pri.*"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
