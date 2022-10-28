output "function_name" {
  value       = aws_lambda_function.main.function_name
  description = "Name of the created Lambda Function"
}

output "arn" {
  value       = aws_lambda_function.main.arn
  description = "Amazon Resource Name (ARN) identifying your Lambda Function."
}

output "invoke_arn" {
  value       = aws_lambda_function.main.invoke_arn
  description = "ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's `uri`."
}

output "last_modified" {
  value       = aws_lambda_function.main.last_modified
  description = "Date this resource was last modified."
}

output "qualified_arn" {
  value       = aws_lambda_function.main.qualified_arn
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via `publish = true)`."
}

output "qualified_invoke_arn" {
  value       = aws_lambda_function.main.qualified_invoke_arn
  description = "Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's `uri`."
}

output "signing_job_arn" {
  value       = aws_lambda_function.main.signing_job_arn
  description = "ARN of the signing job."
}

output "signing_profile_version_arn" {
  value       = aws_lambda_function.main.signing_profile_version_arn
  description = "ARN of the signing profile version."
}

output "source_code_size" {
  value       = aws_lambda_function.main.source_code_size
  description = "Size in bytes of the function `.zip file`."
}

output "version" {
  value       = aws_lambda_function.main.version
  description = "Latest published version of your Lambda Function."
}

output "config_vpc_id" {
  value       = aws_lambda_function.main.vpc_config.*.vpc_id
  description = "ID of the VPC."
}

output "tags_all" {
  value       = aws_lambda_function.main.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

## Cloudwatch
output "log_group_name" {
  value       = aws_cloudwatch_log_group.lambda.name
  description = "The name of the lambda log group."
}

output "log_group_kms_arn" {
  value       = aws_cloudwatch_log_group.lambda.kms_key_id
  description = "The ARN of the KMS Key used for encrypting lambda log data."
}

output "log_group_arn" {
  value       = aws_cloudwatch_log_group.lambda.arn
  description = "The Amazon Resource Name (ARN) specifying the log group."
}

### Lambda Role
output "lambda_role_id" {
  value       = aws_iam_role.iam_for_lambda.id
  description = "Name of the lambda role."
}

output "lambda_role_arn" {
  value       = aws_iam_role.iam_for_lambda.arn
  description = "Amazon Resource Name (ARN) specifying the lambda role."
}

### Lambda KMS
output "lambda_kms_arn" {
  value       = join("", aws_kms_key.cloudwatch.*.arn)
  description = "The Amazon Resource Name (ARN) of the lambda key."
}

output "lambda_kms_id" {
  value       = join("", aws_kms_key.cloudwatch.*.key_id)
  description = "The globally unique identifier for the lambda kms key."
}

### Lambda Layer
output "layer_name" {
  value       = join("", aws_lambda_layer_version.main.*.layer_name)
  description = "Name for your Lambda Layer"
}

output "layer_arn" {
  value       = join("", aws_lambda_layer_version.main.*.arn)
  description = "ARN of the Lambda Layer with version."
}

output "layer_created_date" {
  value       = join("", aws_lambda_layer_version.main.*.created_date)
  description = "Date this resource was created."
}

output "layer_arn_w_version" {
  value       = join("", aws_lambda_layer_version.main.*.layer_arn)
  description = "ARN of the Lambda Layer without version."
}

output "layer_signing_job_arn" {
  value       = join("", aws_lambda_layer_version.main.*.signing_job_arn)
  description = "ARN of a signing job."
}

output "layer_signing_profile_version_arn" {
  value       = join("", aws_lambda_layer_version.main.*.signing_profile_version_arn)
  description = "ARN for a signing profile version."
}

output "layer_source_code_size" {
  value       = join("", aws_lambda_layer_version.main.*.source_code_size)
  description = "Size in bytes of the function .zip file."
}

output "layer_version" {
  value       = join("", aws_lambda_layer_version.main.*.version)
  description = "Lambda Layer version."
}

### Alias
output "alias_arn" {
  value       = [for alias in aws_lambda_alias.main : alias.arn]
  description = "The Amazon Resource Name (ARN) identifying the Lambda function alias."
}

output "alias_invoke_arn" {
  value       = [for alias in aws_lambda_alias.main : alias.invoke_arn]
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's `uri`"
}
