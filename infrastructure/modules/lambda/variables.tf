# assume_role_identifiers:
# This variable defines a list of AWS service principals (e.g., lambda.amazonaws.com)
# that are allowed to assume the IAM role. It is used to configure the trust relationship
# policy for the role. Ensure that only the required services are included to follow
# the principle of least privilege.
variable "assume_role_identifiers" {
  type    = list(string)
  description = "List of AWS service principals (e.g., lambda.amazonaws.com) that are allowed to assume the IAM role"
  default = []
}

# Variable for managed policy ARNs to attach to the IAM role
# This variable defines a list of AWS managed policy ARNs to attach to the IAM role.
# These policies grant the necessary permissions for the role to interact with AWS services.
# Example policies:
# - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole: Grants permissions to write logs to CloudWatch.
# - arn:aws:iam::aws:policy/SecretsManagerReadWrite: Provides access to manage secrets in Secrets Manager.
variable "managed_policy_arns" {
  type        = list(string)
  description = "List of managed policy ARNs to attach to the Lambda execution role"
  default     = []
}

variable "lambda_name" {
  type        = string
  description = "Lambda function name"
}

variable "description" {
  type        = string
  default     = ""
}

variable "handler" {
  type        = string
  default     = "handler.handler"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
}

variable "memory_size" {
  type        = number
  default     = 128
}

variable "timeout" {
  type        = number
  default     = 10
}

variable "s3_bucket" {
  type        = string
}

variable "s3_key" {
  type        = string
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
}

variable "log_retention" {
  type        = number
  default     = 14
}

variable "layers" {
  type        = list(string)
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for the Lambda function. Use -1 for no limit."
  type        = number
  default     = -1
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Lambda function VPC configuration"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function VPC configuration"
  type        = list(string)
  default     = []
}
