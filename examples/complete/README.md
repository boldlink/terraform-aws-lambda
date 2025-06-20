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

# Terraform module example of complete and most common configuration


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete_lambda_example"></a> [complete\_lambda\_example](#module\_complete\_lambda\_example) | ../.. | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | boldlink/efs/aws | 1.2.0 |
| <a name="module_external_kms"></a> [external\_kms](#module\_external\_kms) | boldlink/kms/aws | 1.2.0 |
| <a name="module_lambda_with_ext_kms"></a> [lambda\_with\_ext\_kms](#module\_lambda\_with\_ext\_kms) | ../.. | n/a |
| <a name="module_lambda_with_s3"></a> [lambda\_with\_s3](#module\_lambda\_with\_s3) | ../.. | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | boldlink/s3/aws | 2.5.1 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.access_point_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_sqs_queue.example_dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [null_resource.layers](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.s3](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.requests](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately. | `number` | `7` | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | Name of the supporting resources stack | `string` | `"terraform-aws-lambda"` | no |

## Outputs

No outputs.
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

#### BOLDLink-SIG 2023
