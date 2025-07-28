# ---------#
# IAM ROLE #
# ---------#
data "aws_iam_policy_document" "assume_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      # TODO: This should be passed from terragrunt
      identifiers = ["lambda.amazonaws.com", "athena.amazonaws.com", "glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.lambda_name}-exec-role"
  description        = "IAM role for Lambda function ${var.lambda_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda.json
  tags               = var.tags
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "managed_policies_attachment" {
  for_each   = toset(var.managed_policy_arn)
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = each.value
}


# ----------#
# LOG GROUP #
# ----------#
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = var.log_retention
  # TODO: Check these variables again
  skip_destroy = true
  tags         = var.tags
}


# ----------------#
# Lambda Function #
# ----------------#
resource "aws_lambda_function" "this" {
  function_name = var.lambda_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec_role.arn

  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions

  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  s3_object_version = var.s3_object_version

  environment {
    variables = var.environment_variables
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  layers = var.layers

  tags = var.tags
}