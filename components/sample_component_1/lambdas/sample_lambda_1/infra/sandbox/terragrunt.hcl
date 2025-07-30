terraform {
  source = "${get_repo_root()}/infrastructure/modules//lambda"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path = "${get_repo_root()}/infrastructure/environments/sandbox/env.hcl"
}

inputs = {
  # log group vars
  log_retention          = 14

  # iam role vars
  assume_role_identifiers = ["lambda.amazonaws.com"]
  managed_policy_arns     = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/SecretsManagerReadWrite", "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole", "arn:aws:iam::aws:policy/AmazonSQSFullAccess"]

  # lambda function vars
  lambda_name            = "sample_lambda_1"
  description            = "Sample Lambda Function"
  handler                = "components.sample_component_1.lambdas.sample_lambda_1.src.handler.lambda_handler"
  runtime                = "python3.13"
  memory_size            = 128
  timeout                = 30
  s3_bucket              = "013186329397-my-lambda-bucket"
  s3_key                 = "sample_lambda_1.zip"
  environment_variables  = {
    ENV = "sandbox"
  }
  layers                 = null
  tags                   = {
    Project = "SampleProject"
    Env     = "sandbox"
  }
}