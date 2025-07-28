output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}
