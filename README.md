[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-lambda/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-lambda.svg)](https://github.com/boldlink/terraform-aws-lambda/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# AWS Lambda Terraform module

## Description

Boldlink AWS Lambda module has been scanned with Checkov to ensure its resources and default configurations are provided to you following known standards and best practices.

### Why choose this module over the standard resouces
- AWS Cloudwatch Log Group for the created lambda function are encrypted using AWS CMK key by default and support other encryption options.
- Default configurations have been validated by Chekov to ensure best practices and security.
- Configurable IAM permissions for your Lambda function with supported AWS services, on top of the default permissions created by the module. This is specified by using the `additional_lambda_permissions` variable.
- Lambda alias included as a default
- Lambda layers to install external code dependencies to the lambda function
- Lambda layer permission to grant cross account functions to use the lambda layers created

Examples available [`here`](./examples)

A variable defined as `map(any)` type means it can be a mix of strings, list of strings and map of strings, for example;
```console
vpc_config = {
  security_group_ids = ["sg-1234567898id1", "sg-1234567898id2"]
  subnet_ids         = ["subnet-1234567898id1", "subnet-1234567898id2"]
}

file_system_config = {
  # EFS file system access point ARN
  arn = "EFS_ACCESS_POINT_ARN_HERE"
  # Local mount path inside the lambda function. Must start with '/mnt/'.
  local_mount_path = "/mnt/efs"
}

image_config = {
  command           = "<provide_command_here>"
  entry_point       = "<specify_entrypoint>"
  working_directory = "specify_working_directory"
}
```

See how other variables with the same type have been used in [`complete example`](./examples/complete/main.tf)

## Usage
*NOTE*: These examples use the latest version of this module

```hcl
module "minimum_lambda_example" {
  #checkov:skip=CKV_AWS_50:X-ray tracing is enabled for Lambda
  source                        = "boldlink/lambda/aws"
  version                       = "<latest_module_version>"
  function_name                 = local.function_name
  description                   = "Lambda function to stop EC2 instances"
  filename                      = "lambda.zip"
  handler                       = "example.lambda_handler"
  publish                       = true
  runtime                       = "python3.9"
  source_code_hash              = data.archive_file.lambda_zip.output_base64sha256
  additional_lambda_permissions = local.additional_lambda_permissions
  tags                          = local.tags

  tracing_config = {
    mode = "Active"
  }
}
```
## Documentation

[AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

[Terraform module documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_alias.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_layer_version.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_layer_version_permission.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version_permission) | resource |
| [aws_lambda_permission.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_lambda_permissions"></a> [additional\_lambda\_permissions](#input\_additional\_lambda\_permissions) | Add additional iam policy statements for the lambda created by this module | `any` | `{}` | no |
| <a name="input_additional_layers"></a> [additional\_layers](#input\_additional\_layers) | (Optional) List of Lambda Layer Version (maximum of 5) to attach to your Lambda Function | `list(string)` | `[]` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | Configuration for lambda alias | `map(any)` | `{}` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | (Optional) Instruction set architecture for your Lambda function. Valid values are `["x86_64"]` and `["arm64"]`. Default is `["x86_64"]`. Removing this attribute, function's architecture stay the same. | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | (Optional) To enable code signing for this function, specify the ARN of a code-signing configuration. A code-signing configuration includes a set of signing profiles, which define the trusted publishers for this function. | `string` | `null` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether to create KMS  key or not | `bool` | `false` | no |
| <a name="input_create_lambda_invocation"></a> [create\_lambda\_invocation](#input\_create\_lambda\_invocation) | Whether to create lambda invocation resource | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a Security Group for the lambda function. | `bool` | `false` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | Dead letter queue configuration that specifies the queue or topic where Lambda sends asynchronous events when they fail processing. | `map(any)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of what your Lambda Function does. | `string` | `null` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Choose whether to enable key rotation for cloudwatch kms key | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) Map of environment variables that are accessible from the function code during execution. | `map(any)` | `{}` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | Configuration block for the size of the Lambda function Ephemeral storage(/tmp) represented in MB. | `map(any)` | `{}` | no |
| <a name="input_file_system_config"></a> [file\_system\_config](#input\_file\_system\_config) | Connection settings for an EFS file system. Before creating or updating Lambda functions with `file_system_config`, EFS mount targets must be in available lifecycle state. | `map(any)` | `{}` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | (Optional) Path to the function's deployment package within the local filesystem. Conflicts with `image_uri`, `s3_bucket`, `s3_key`, and `s3_object_version`. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | (Required) Unique name for your Lambda Function. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | (Optional) Function entrypoint in your code. | `string` | `null` | no |
| <a name="input_image_config"></a> [image\_config](#input\_image\_config) | Container image configuration values that override the values in the container image Dockerfile. | `map(any)` | `{}` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | (Optional) ECR image URI containing the function's deployment package. Conflicts with `filename`, `s3_bucket`, `s3_key`, and `s3_object_version`. | `string` | `null` | no |
| <a name="input_input"></a> [input](#input\_input) | (Required) JSON payload to the lambda function. | `any` | `""` | no |
| <a name="input_key_deletion_window_in_days"></a> [key\_deletion\_window\_in\_days](#input\_key\_deletion\_window\_in\_days) | The number of days before the cloudwatch kms key is deleted | `number` | `7` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Optional) Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key. If this configuration is provided when environment variables are not in use, the AWS Lambda API does not save this configuration and Terraform will show a perpetual difference of adding the key. To fix the perpetual difference, remove this configuration. | `string` | `null` | no |
| <a name="input_lambda_permissions"></a> [lambda\_permissions](#input\_lambda\_permissions) | Configuration to give external source(s) (like an EventBridge Rule, SNS, or S3) permission to access the Lambda function. | `list(any)` | `[]` | no |
| <a name="input_layer_permission"></a> [layer\_permission](#input\_layer\_permission) | Configuration to allow sharing of Lambda Layers to another account by account ID, to all accounts in AWS organization or even to all AWS accounts. | `map(any)` | `{}` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | (Optional) Map of Lambda Layers to create and attach to your Lambda Function | `map(any)` | `{}` | no |
| <a name="input_lifecycle_scope"></a> [lifecycle\_scope](#input\_lifecycle\_scope) | (Optional) Lifecycle scope of the resource to manage. Valid values are CREATE\_ONLY and CRUD. Defaults to CREATE\_ONLY. CREATE\_ONLY will invoke the function only on creation or replacement. CRUD will invoke the function on each lifecycle event, and augment the input JSON payload with additional lifecycle information. | `string` | `"CREATE_ONLY"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | (Optional) Amount of memory in MB your Lambda Function can use at runtime. Defaults to `128` | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | (Optional) Lambda deployment package type. Valid values are `Zip` and `Image`. Defaults to `Zip` | `string` | `"Zip"` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | (Optional) Whether to publish creation/change as new Lambda Function Version. Defaults to `false` | `bool` | `false` | no |
| <a name="input_qualifier"></a> [qualifier](#input\_qualifier) | (Optional) Qualifier (i.e., version) of the lambda function. Defaults to $LATEST. | `string` | `"$LATEST"` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | (Optional) Amount of reserved concurrent executions for this lambda function. A value of `0` disables lambda from being triggered and `-1` removes any concurrency limitations. Defaults to Unreserved Concurrency Limits `-1` | `number` | `-1` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `1827` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | (Optional) Identifier of the function's runtime. | `string` | `null` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | (Optional) S3 bucket location containing the function's deployment package. Conflicts with filename and image\_uri. This bucket must reside in the same AWS region where you are creating the Lambda function. | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | (Optional) S3 key of an object containing the function's deployment package. Conflicts with `filename` and `image_uri`. | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | (Optional) Object version containing the function's deployment package. Conflicts with filename and image\_uri. | `string` | `null` | no |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | (Optional) Egress rules to add to the security group | `any` | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs associated with the Lambda function. | `list(string)` | `[]` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | (Optional) Ingress rules to add to the security group | `any` | `{}` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | (Optional) Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3\_key. The usual way to set this is `filebase64sha256("file.zip")` (Terraform 0.11.12 and later) or `base64sha256(file("file.zip"))` (Terraform 0.11.11 and earlier), where "file.zip" is the local filename of the lambda function source archive. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs associated with the Lambda function. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the object. | `map(string)` | `{}` | no |
| <a name="input_terraform_key"></a> [terraform\_key](#input\_terraform\_key) | (Optional) The JSON key used to store lifecycle information in the input JSON payload. Defaults to tf. This additional key is only included when lifecycle\_scope is set to CRUD. | `string` | `"tf"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | (Optional) Amount of time your Lambda Function has to run in seconds. | `number` | `7` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts configuration for creating the resource | `map(string)` | `{}` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Configuration block for whether to to sample and trace a subset of incoming requests with AWS X-Ray | `map(any)` | `{}` | no |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | (Optional) Map of arbitrary keys and values that, when changed, will trigger a re-invocation. | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID. Defaults to the region's default VPC. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn) | The Amazon Resource Name (ARN) identifying the Lambda function alias. |
| <a name="output_alias_invoke_arn"></a> [alias\_invoke\_arn](#output\_alias\_invoke\_arn) | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's `uri` |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) identifying your Lambda Function. |
| <a name="output_config_vpc_id"></a> [config\_vpc\_id](#output\_config\_vpc\_id) | ID of the VPC. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the created Lambda Function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | ARN to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's `uri`. |
| <a name="output_lambda_kms_arn"></a> [lambda\_kms\_arn](#output\_lambda\_kms\_arn) | The Amazon Resource Name (ARN) of the lambda key. |
| <a name="output_lambda_kms_id"></a> [lambda\_kms\_id](#output\_lambda\_kms\_id) | The globally unique identifier for the lambda kms key. |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | Amazon Resource Name (ARN) specifying the lambda role. |
| <a name="output_lambda_role_id"></a> [lambda\_role\_id](#output\_lambda\_role\_id) | Name of the lambda role. |
| <a name="output_last_modified"></a> [last\_modified](#output\_last\_modified) | Date this resource was last modified. |
| <a name="output_layer_arn"></a> [layer\_arn](#output\_layer\_arn) | ARN of the Lambda Layer with version. |
| <a name="output_layer_arn_without_version"></a> [layer\_arn\_without\_version](#output\_layer\_arn\_without\_version) | ARN of the Lambda Layer without version. |
| <a name="output_layer_created_date"></a> [layer\_created\_date](#output\_layer\_created\_date) | Date this resource was created. |
| <a name="output_layer_name"></a> [layer\_name](#output\_layer\_name) | Name for your Lambda Layer |
| <a name="output_layer_signing_job_arn"></a> [layer\_signing\_job\_arn](#output\_layer\_signing\_job\_arn) | ARN of a signing job. |
| <a name="output_layer_signing_profile_version_arn"></a> [layer\_signing\_profile\_version\_arn](#output\_layer\_signing\_profile\_version\_arn) | ARN for a signing profile version. |
| <a name="output_layer_source_code_size"></a> [layer\_source\_code\_size](#output\_layer\_source\_code\_size) | Size in bytes of the function .zip file. |
| <a name="output_layer_version"></a> [layer\_version](#output\_layer\_version) | Lambda Layer version. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The Amazon Resource Name (ARN) specifying the log group. |
| <a name="output_log_group_kms_arn"></a> [log\_group\_kms\_arn](#output\_log\_group\_kms\_arn) | The ARN of the KMS Key used for encrypting lambda log data. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the lambda log group. |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | ARN identifying your Lambda Function Version (if versioning is enabled via `publish = true)`. |
| <a name="output_qualified_invoke_arn"></a> [qualified\_invoke\_arn](#output\_qualified\_invoke\_arn) | Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's `uri`. |
| <a name="output_result"></a> [result](#output\_result) | String result of the lambda function invocation. |
| <a name="output_signing_job_arn"></a> [signing\_job\_arn](#output\_signing\_job\_arn) | ARN of the signing job. |
| <a name="output_signing_profile_version_arn"></a> [signing\_profile\_version\_arn](#output\_signing\_profile\_version\_arn) | ARN of the signing profile version. |
| <a name="output_source_code_size"></a> [source\_code\_size](#output\_source\_code\_size) | Size in bytes of the function `.zip file`. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_version"></a> [version](#output\_version) | Latest published version of your Lambda Function. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC module) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

Resources on the `tests/supportingResources` folder are not intended for demo or actual implementation purposes, and can be used for reference.

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```


#### BOLDLink-SIG 2023
