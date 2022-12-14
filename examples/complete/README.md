[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lambda/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lambda/actions)
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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete_lambda_example"></a> [complete\_lambda\_example](#module\_complete\_lambda\_example) | ../.. | n/a |
| <a name="module_lambda_vpc"></a> [lambda\_vpc](#module\_lambda\_vpc) | boldlink/vpc/aws | 2.0.3 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

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

#### BOLDLink-SIG 2022
