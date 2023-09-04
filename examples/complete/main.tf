module "complete_lambda_example" {
  source = "../.."
  #checkov:skip=CKV_AWS_50:X-ray tracing is enabled for Lambda
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
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
  create_lambda_invocation = true
  create_security_group    = true
  vpc_id                   = local.vpc_id

  ## See `additional_lambda_permissions` in locals for the permissions required to access/use vpc resources (for NetworkInterface and Instances)
  subnet_ids = local.private_subnets

  tracing_config = {
    mode = "Active"
  }

  security_group_ingress_rules = {
    default = {
      description = "Custom ingress traffic allowed to lambda function"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
    }
  }

  security_group_egress_rules = {
    default = {
      description = "Custom egress traffic allowed to lambda function"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
