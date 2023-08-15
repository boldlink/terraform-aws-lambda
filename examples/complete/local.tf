locals {
  function_name = "complete-lambda-example"
  private_subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]
  private_subnets = local.private_subnet_id
  vpc_id          = data.aws_vpc.supporting.id
  vpc_cidr        = data.aws_vpc.supporting.cidr_block
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
