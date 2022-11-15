locals {
  function_name = "minimum-lambda-example"
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
        "ec2:StopInstances"
      ]
      resources = ["*"]
    }
  }
}
