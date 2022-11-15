locals {
  function_name   = "complete-lambda-example"
  private_subnets = [cidrsubnet(local.cidr_block, 8, 4), cidrsubnet(local.cidr_block, 8, 5), cidrsubnet(local.cidr_block, 8, 6)]
  public_subnets  = [cidrsubnet(local.cidr_block, 8, 1), cidrsubnet(local.cidr_block, 8, 2), cidrsubnet(local.cidr_block, 8, 3)]
  region          = data.aws_region.current.id
  account_id      = data.aws_caller_identity.current.id
  azs             = flatten(data.aws_availability_zones.available.names)
  cidr_block      = "10.1.0.0/16"
  tags = {
    Name               = local.function_name
    Environment        = "examples"
    "user::CostCenter" = "terraform"
    department         = "operations"
    instance-scheduler = false
    LayerName          = "c900-aws-lambda"
    LayerId            = "c900"
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
        "ec2:DescribeNetworkInterfaces"
      ]
      resources = ["*"]
    }
  }
}
