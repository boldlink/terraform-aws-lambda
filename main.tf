resource "aws_lambda_function" "main" {
  function_name                  = var.function_name
  role                           = aws_iam_role.iam_for_lambda.arn
  architectures                  = var.architectures
  code_signing_config_arn        = var.code_signing_config_arn
  description                    = var.description
  filename                       = var.filename
  image_uri                      = var.image_uri
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  handler                        = var.handler
  kms_key_arn                    = var.kms_key_arn
  layers                         = try(aws_lambda_layer_version.main.*.arn, [])
  memory_size                    = var.memory_size
  package_type                   = var.package_type
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  source_code_hash               = var.source_code_hash
  tags                           = var.tags
  timeout                        = var.timeout

  dynamic "dead_letter_config" {
    for_each = length(keys(var.dead_letter_config)) > 0 ? [var.dead_letter_config] : []
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment)) > 0 ? [var.environment] : []
    content {
      variables = try(environment.value.variables, null)
    }
  }

  dynamic "ephemeral_storage" {
    for_each = length(keys(var.ephemeral_storage)) > 0 ? [var.ephemeral_storage] : []
    content {
      size = try(ephemeral_storage.value.size, null)
    }
  }

  dynamic "file_system_config" {
    for_each = length(keys(var.file_system_config)) > 0 ? [var.file_system_config] : []
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  dynamic "image_config" {
    for_each = length(keys(var.image_config)) > 0 ? [var.image_config] : []
    content {
      command           = try(image_config.value.command, null)
      entry_point       = try(image_config.value.entry_point, null)
      working_directory = try(image_config.value.working_directory, null)
    }
  }

  dynamic "tracing_config" {
    for_each = length(keys(var.tracing_config)) > 0 ? [var.tracing_config] : []
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.subnet_ids != null && (var.create_security_group || length(var.security_group_ids) != 0) ? [true] : []
    content {
      security_group_ids = compact(concat([aws_security_group.main[0].id], var.security_group_ids))
      subnet_ids         = var.subnet_ids
    }
  }

  timeouts {
    create = try(var.timeouts["create"], "10m")
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda,
  ]
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.log_group_kms_arn == null ? aws_kms_key.cloudwatch[0].arn : var.log_group_kms_arn
  tags              = var.tags
}

####################
### Permissions
####################
resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.function_name}-lambda-logging"
  path        = "/"
  description = "IAM policy for logging from ${var.function_name}"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_kms_key" "cloudwatch" {
  count                   = var.log_group_kms_arn == null ? 1 : 0
  description             = "${var.function_name} Log Group KMS key"
  enable_key_rotation     = var.enable_key_rotation
  policy                  = local.kms_policy
  deletion_window_in_days = var.key_deletion_window_in_days
  tags                    = var.tags
}

##################
## Lambda Layers
##################
resource "aws_lambda_layer_version" "main" {
  count                    = length(var.layers) > 0 ? length(var.layers) : 0
  filename                 = try(var.layers[count.index]["filename"], null)
  layer_name               = try(var.layers[count.index]["layer_name"])
  compatible_runtimes      = try(var.layers[count.index]["compatible_runtimes"], null)
  compatible_architectures = try([var.layers[count.index]["compatible_architectures"]], [])
  description              = try(var.layers[count.index]["description"], null)
  license_info             = try(var.layers[count.index]["license_info"], null)
  s3_bucket                = try(var.layers[count.index]["s3_bucket"], null)
  s3_key                   = try(var.layers[count.index]["s3_key"], null)
  s3_object_version        = try(var.layers[count.index]["s3_object_version"], null)
  skip_destroy             = try(var.layers[count.index]["skip_destroy"], null)
  source_code_hash         = try(var.layers[count.index]["source_code_hash"], null)
}

resource "aws_lambda_layer_version_permission" "main" {
  count           = length(var.layers_permission) > 0 ? length(var.layers_permission) : 0
  action          = try(var.lambda_permissions[count.index]["action"])
  layer_name      = try(var.lambda_permissions[count.index]["layer_name"])
  organization_id = try(var.lambda_permissions[count.index]["organization_id"])
  principal       = try(var.lambda_permissions[count.index]["principal"])
  statement_id    = try(var.lambda_permissions[count.index]["statement_id"])
  version_number  = try(var.lambda_permissions[count.index]["version_number"])
}

resource "aws_lambda_permission" "main" {
  count                  = length(var.lambda_permissions) > 0 ? length(var.lambda_permissions) : 0
  action                 = try(var.lambda_permissions[count.index]["action"])
  event_source_token     = try(var.lambda_permissions[count.index]["event_source_token"], null)
  function_name          = aws_lambda_function.main.function_name
  function_url_auth_type = try(var.lambda_permissions[count.index]["function_url_auth_type"], null)
  principal              = try(var.lambda_permissions[count.index]["principal"])
  qualifier              = try(var.lambda_permissions[count.index]["qualifier"], null)
  source_account         = try(var.lambda_permissions[count.index]["source_account"], null)
  source_arn             = try(var.lambda_permissions[count.index]["source_arn"], null)
  statement_id           = try(var.lambda_permissions[count.index]["statement_id"], null)
  statement_id_prefix    = try(var.lambda_permissions[count.index]["statement_id_prefix"], null)
  principal_org_id       = try(var.lambda_permissions[count.index]["principal_org_id"], null)
}

resource "aws_lambda_alias" "main" {
  for_each         = var.alias
  name             = try(each.value.name, each.key)
  description      = try(each.value.description, null)
  function_name    = aws_lambda_function.main.function_name
  function_version = try(each.value.function_version, each.key)

  routing_config {
    additional_version_weights = try([each.value.routing_config.additional_version_weights], [])
  }
}

## Security Group

resource "aws_security_group" "main" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.function_name}-security-group"
  vpc_id      = var.vpc_id
  description = "${var.function_name} Security Group"
  tags        = var.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each                 = var.security_group_ingress_rules
  type                     = "ingress"
  description              = lookup(each.value, "description", null)
  from_port                = lookup(each.value, "from_port")
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol", "tcp")
  cidr_blocks              = lookup(each.value, "cidr_blocks", [])
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  self                     = lookup(each.value, "self", null)
  security_group_id        = aws_security_group.main[0].id
}

resource "aws_security_group_rule" "egress" {
  for_each                 = var.security_group_egress_rules
  type                     = "egress"
  description              = lookup(each.value, "description", null)
  from_port                = lookup(each.value, "from_port")
  to_port                  = lookup(each.value, "to_port")
  protocol                 = lookup(each.value, "protocol", "-1")
  cidr_blocks              = lookup(each.value, "cidr_blocks", [])
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  self                     = lookup(each.value, "self", null)
  security_group_id        = aws_security_group.main[0].id
}


resource "aws_lambda_invocation" "main" {
  count           = var.create_lambda_invocation ? 1 : 0
  function_name   = aws_lambda_function.main.function_name
  input           = var.input
  lifecycle_scope = var.lifecycle_scope
  qualifier       = var.qualifier
  terraform_key   = var.terraform_key
  triggers        = var.triggers
  depends_on      = [aws_lambda_function.main]
}
