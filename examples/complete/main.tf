resource "null_resource" "layers" {
  provisioner "local-exec" {
    command = "pip3 install requests -t layers --upgrade"
  }
}

#######################
## Complete example
#######################

resource "aws_efs_access_point" "access_point_for_lambda" {
  file_system_id = module.efs.file_system_id
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

resource "aws_sqs_queue" "example_dead_letter_queue" {
  name              = "${local.function_name}-dlq"
  kms_master_key_id = "alias/aws/sqs"
}

module "efs" {
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
  security_group_ids            = module.efs.security_group_id

  layers = {
    requests = {
      filename                 = "requests.zip"
      layer_name               = "requests"
      compatible_runtimes      = ["python3.9"]
      compatible_architectures = ["x86_64"]
      description              = "Example lambda layer version"
      skip_destroy             = false
      source_code_hash         = data.archive_file.requests.output_base64sha256
      license_info             = "https://opensource.org/license/mit/"
    }
  }

  layer_permission = {
    requests = {
      layer_name      = "requests"
      principal       = "*"
      organization_id = local.organization_id
      action          = "lambda:GetLayerVersion"
      statement_id    = "example-account"
      skip_destroy    = false
    }
  }

  lambda_permissions = [
    {
      statement_id = "AllowExecutionFromEventBridge"
      action       = "lambda:InvokeFunction"
      principal    = "events.amazonaws.com"
      source_arn   = "arn:aws:events:eu-west-1:111122223333:rule/example"
    }
  ]

  alias = {
    default = {
      name        = local.function_name
      description = "Example function alias"
    }
  }

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
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
  })
  lifecycle_scope       = "CRUD"
  qualifier             = "$LATEST"
  terraform_key         = "tf"
  triggers              = { redeployment = sha1(jsonencode([module.complete_lambda_example.qualified_invoke_arn])) }
  create_security_group = true
  vpc_id                = local.vpc_id

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
    update = "30m"
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

  depends_on = [null_resource.layers, aws_efs_access_point.access_point_for_lambda, module.efs]
}

#################################################
## lambda function with External KMS
#################################################

module "external_kms" {
  source                  = "boldlink/kms/aws"
  version                 = "1.2.0"
  description             = "Example complete kms key with IAM user permisions"
  alias_name              = "alias/${local.function_name}-external-kms"
  create_kms_alias        = true
  kms_policy              = local.kms_policy
  deletion_window_in_days = var.deletion_window_in_days
  tags                    = local.tags
}

module "lambda_with_ext_kms" { ## Especially for encrypting environment variables
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
  kms_key_arn                   = module.external_kms.arn
    environment = {
    variables = {
      department = "Operations"
    }
  }

  tracing_config = {
    mode = "Active"
  }
  depends_on = [module.external_kms]
}

###################################################################
## lambda function with deployment packages stored in an s3 bucket
###################################################################

module "s3_bucket" {
  source        = "boldlink/s3/aws"
  version       = "2.3.1"
  bucket        = lower("${local.function_name}-bucket")
  force_destroy = true
  tags          = local.tags
}
resource "null_resource" "s3" {
  provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/ s3://${module.s3_bucket.id} --recursive --exclude '*' --include '*.zip'"
  }
  depends_on = [null_resource.layers, data.archive_file.lambda_zip, data.archive_file.requests, module.s3_bucket]
}

module "lambda_with_s3" {
  source = "../.."
  #checkov:skip=CKV_AWS_50:X-ray tracing is enabled for Lambda
  function_name                 = "${local.function_name}-with-s3"
  description                   = "Lambda function with deployment packages stored in an s3 bucket"
  s3_bucket                     = module.s3_bucket.id
  s3_key                        = data.archive_file.lambda_zip.output_path
  handler                       = "example.lambda_handler"
  publish                       = true
  runtime                       = "python3.9"
  source_code_hash              = data.archive_file.lambda_zip.output_base64sha256
  additional_lambda_permissions = local.additional_lambda_permissions
  tags                          = local.tags

  layers = {
    requests-s3 = {
      s3_bucket           = module.s3_bucket.id
      s3_key              = data.archive_file.requests.output_path
      compatible_runtimes = ["python3.9"]
      description         = "Example lambda layer version with deployment package stored in s3"
      source_code_hash    = data.archive_file.requests.output_base64sha256
    }
  }

  tracing_config = {
    mode = "Active"
  }
  depends_on = [module.s3_bucket, null_resource.s3]
}
