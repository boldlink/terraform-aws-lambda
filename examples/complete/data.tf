data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./boto"
  output_path = "lambda.zip"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
