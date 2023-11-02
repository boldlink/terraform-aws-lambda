locals {
  region              = data.aws_region.current.name
  partition           = data.aws_partition.current.partition
  account_id          = data.aws_caller_identity.current.account_id
  organization_id     = data.aws_organizations_organization.current.id
  dns_suffix          = data.aws_partition.current.dns_suffix
  function_name       = "complete-lambda-example"
  private_subnet_ids  = [for i in data.aws_subnet.private : i.id]
  private_subnet_cidr = [for s in data.aws_subnet.private : s.cidr_block]
  private_subnets     = local.private_subnet_ids
  ip_addresses        = [for cidr in local.private_subnet_cidr : cidrhost(cidr, 5)]
  vpc_id              = data.aws_vpc.supporting.id
  vpc_cidr            = data.aws_vpc.supporting.cidr_block
  tags = {
    Name               = local.function_name
    Environment        = "examples"
    Project            = "terraform-modules"
    "user::CostCenter" = "terraform"
    Department         = "operations"
    LayerName          = "c900-aws-lambda"
    LayerId            = "c900"
    Owner              = "Boldlink"
  }
  additional_lambda_permissions = {
    statement = {
      sid    = "AllowLambdaActions"
      effect = "Allow"
      actions = [
        "ec2:DescribeInstances",
        "ec2:StopInstances",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "sqs:SendMessage"
      ]
      resources = ["*"]
    }
  }
  kms_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow Cloud Watch Logs",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${local.region}.${local.dns_suffix}"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:${local.partition}:iam::${local.account_id}:root"
        },
        "Action" : [
          "kms:*"
        ],
        "Resource" : "*",
      }
    ]
  })
}
