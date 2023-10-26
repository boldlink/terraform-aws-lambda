
resource "aws_sqs_queue" "example_dead_letter_queue" {
  name              = "${local.function_name}-dlq"
  kms_master_key_id = "alias/aws/sqs"
}

module "complete_lambda_example" {
  source = "../.."
  #checkov:skip=CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
  function_name                 = local.function_name
  description                   = "Lambda function to stop EC2 instances"
  filename                      = "lambda.zip"
  handler                       = "example.lambda_handler"
  publish                       = true
  create_kms_key                = true
  runtime                       = "python3.9"
  source_code_hash              = data.archive_file.lambda_zip.output_base64sha256
  additional_lambda_permissions = local.additional_lambda_permissions
  tags                          = local.tags
  security_group_ids            = module.lambda_efs.security_group_id

  dead_letter_config = {
    target_arn = aws_sqs_queue.example_dead_letter_queue.arn
  }

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

  file_system_config = {
    arn              = aws_efs_access_point.access_point_for_lambda.arn
    local_mount_path = "/mnt/efs"
  }

  timeouts = {
    delete = "30m"
    create = "30m"
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

  depends_on = [aws_efs_access_point.access_point_for_lambda,
  module.lambda_efs]
}


module "lambda_efs" {
  source                    = "boldlink/efs/aws"
  version                   = "1.2.0"
  creation_token            = "${local.function_name}-efs"
  mount_target_subnet_ids   = local.private_subnets
  vpc_id                    = local.vpc_id
  tags                      = local.tags
  create_security_group     = true
  mount_target_ip_addresses = local.ip_addresses
  security_group_ingress = [
    {
      description = "efs ingress rule for port 2049"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
    }
  ]

  egress_rules = {
    allow_all-egress = {
      description = "Allow all egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = module.lambda_efs.file_system_id
  tags           = local.tags

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
}

## External KMS

module "lambda_kms" {
  source                  = "boldlink/kms/aws"
  version                 = "1.2.0"
  description             = "Example complete kms key with IAM user permisions"
  alias_name              = "alias/${local.function_name}-external-kms"
  create_kms_alias        = true
  kms_policy              = local.kms_policy
  deletion_window_in_days = var.deletion_window_in_days
  tags                    = local.tags
}

module "external_key" {
  source = "../.."
  #checkov:skip=CKV_AWS_50:X-ray tracing is enabled for Lambda
  function_name                 = "${local.function_name}-ext-kms"
  description                   = "Lambda function to stop EC2 instances"
  filename                      = "lambda.zip"
  handler                       = "example.lambda_handler"
  publish                       = true
  runtime                       = "python3.9"
  source_code_hash              = data.archive_file.lambda_zip.output_base64sha256
  additional_lambda_permissions = local.additional_lambda_permissions
  tags                          = local.tags
  kms_key_arn                   = module.lambda_kms.arn

  tracing_config = {
    mode = "Active"
  }
}
