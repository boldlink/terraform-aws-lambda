resource "aws_security_group" "lambda" {
  #checkov:skip=CKV2_AWS_5
  name        = local.function_name
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  egress {
    description      = "lambda egress rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags

  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties.
    create_before_destroy = true
  }
}

module "complete_lambda_example" {
  source = "../.."
  #checkov:skip=CKV_AWS_50:X-ray tracing is enabled for Lambda
  function_name                 = local.function_name
  description                   = "Lambda function to stop EC2 instances"
  filename                      = "lambda.zip"
  handler                       = "example.lambda_handler"
  publish                       = true
  runtime                       = "python3.9"
  source_code_hash              = data.archive_file.lambda_zip.output_base64sha256
  additional_lambda_permissions = local.additional_lambda_permissions
  tags                          = local.tags

  environment = {
    variables = {
      department = "Operations"
    }
  }

  ephemeral_storage = {
    size = 512
  }

  ## See `additional_lambda_permissions` in locals for the permissions required to access/use vpc resources (for NetworkInterface and Instances)
  vpc_config = {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids         = local.private_subnets
  }

  tracing_config = {
    mode = "Active"
  }
}
