# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- feat: Add Provisioned Concurrency Configuration.
- feat: Add lambda event source mapping
- feat: Add Lambda function URL
- feat: Add Event Invoke Config
- feat: Show more usage of the features in complete/specific feature examples
- fix: CKV_AWS_50: "X-ray tracing is enabled for Lambda"
- fix: CKV2_AWS_5: "Ensure that Security Groups are attached to another resource"
- lambda example with S3 bucket being the location containing the function's deployment package
- lambda example with ECR URI being the location containing the function's deployment package and add image configurations
- add an example that has code_signing_config_arn
- add an example with the following lambda permission attributes: qualifier, principle_org_id, statement_id_prefix, source_account, event_source_token, function_url_auth_type


## [1.1.1] - 2023-10-26
- fix: module's kms key
- fix: security group ids
- fix: lambda function timeouts block
- lambda function example that uses external KMS key for env variables and CloudWatch encryption
- added dead letter queue SQS to complete example
- added file system configuration to complete example
- removed alias routing configuration, the latest function version is already included in routing configuration.
- refactored lambda layers and lambda layer permission blocks
- add an example that has it deployment package in an s3 bucket
- modified lambda layer outputs


## [1.1.0] - 2023-09-04
- feat: lambda invocation resource for the module
- feat: security group and security group rules resources for the module

## [1.0.1] - 2023-08-15
- fix: VPC version used in supporting resources. This is to fix pre-commit errors from deprecated outputs

## [1.0.0] - 2022-10-26
### Description
- feat: included all the viable/basic features for a working lambda function
- feat: included the permissions required by the lambda function resource
- feat: included an option to provide extra permissions when using the module
- feat: added lambda alias

## [0.1.0] - 2022-10-20
### Description
- Initial commit
- feat: add files from template repository

[Unreleased]: https://github.com/boldlink/terraform-aws-lambda/compare/1.1.1...HEAD

[1.1.1]: https://github.com/boldlink/terraform-aws-lambda/releases/tag/1.1.1
[1.1.0]: https://github.com/boldlink/terraform-aws-lambda/releases/tag/1.1.0
[1.0.1]: https://github.com/boldlink/terraform-aws-lambda/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-lambda/releases/tag/1.0.0
[0.1.0]: https://github.com/boldlink/terraform-aws-lambda/releases/tag/0.1.0
