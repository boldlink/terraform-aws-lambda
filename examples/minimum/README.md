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

# Terraform module example with minimum configuration


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
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_minimum_lambda_example"></a> [minimum\_lambda\_example](#module\_minimum\_lambda\_example) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

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
