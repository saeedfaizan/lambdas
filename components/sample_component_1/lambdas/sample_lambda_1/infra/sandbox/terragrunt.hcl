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
  managed_policy_arn     = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  # lambda function vars
  lambda_name            = "sample_lambda_1"
  description            = "Sample Lambda Function"
  handler                = "components.sample_component_1.lambdas.sample_lambda_1.src.handler.lambda_handler"
  runtime                = "python3.13"
  memory_size            = 128
  timeout                = 30
  # TODO: Need to improve this: Code changes are not properly dectected in sample_lambda_1.zip
  s3_bucket              = "my-lambda-bucket-013186329397"
  s3_key                 = "sample_lambda_1.zip"
  s3_object_version      = "U_d7zsI67yUA8v1V8gXSxpwOD21bLmpC"
  environment_variables  = {
    ENV = "sandbox"
  }
  layers                 = null
  tags                   = {
    Project = "SampleProject"
    Env     = "sandbox"
  }
}