module "lambda_vpc" {
  source               = "boldlink/vpc/aws"
  version              = "2.0.3"
  name                 = local.function_name
  account              = local.account_id
  region               = local.region
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true
  create_nat_gateway   = true
  nat_single_az        = true
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  availability_zones   = local.azs
  other_tags           = local.tags
}

resource "aws_security_group" "lambda" {
  name        = local.function_name
  description = "Allow TLS inbound traffic"
  vpc_id      = module.lambda_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }

  egress {
    description = "lambda egress rule"
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

  depends_on = [module.lambda_vpc]
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
    subnet_ids         = flatten([module.lambda_vpc.private_subnet_id])
  }

  tracing_config = {
    mode = "Active"
  }

  depends_on = [module.lambda_vpc]
}
