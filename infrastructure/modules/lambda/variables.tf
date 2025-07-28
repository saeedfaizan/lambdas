variable "managed_policy_arn" {
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

variable "s3_object_version" {
  description = "S3 object version of the Lambda zip file"
  type        = string
}
