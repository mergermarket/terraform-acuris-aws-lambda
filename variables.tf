variable "image_uri" {
  type        = string
  description = "Optional ECR image (for image based lambda)"
  default     = null
}

variable "image_config_command" {
  type        = list(string)
  description = "Optional override of image's CMD"
  default     = null
}

variable "image_config_entry_point" {
  type        = list(string)
  description = "Optional override of image's ENTRYPOINT"
  default     = null
}

variable "image_config_working_directory" {
  type        = string
  description = "Optional override of image's WORKDIR"
  default     = null
}

variable "s3_bucket" {
  type        = string
  description = "The name of the bucket containing your uploaded Lambda deployment package."
  default     = null
}

variable "s3_key" {
  type        = string
  description = "The s3 key for your Lambda deployment package."
  default     = null
}

variable "function_name" {
  type        = string
  description = "The name of the Lambda function."
}

variable "handler" {
  type        = string
  description = "The function within your code that Lambda calls to begin execution."
  default     = null
}

variable "runtime" {
  type        = string
  description = "The runtime environment for the Lambda function you are uploading."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "The VPC subnets in which the Lambda runs."
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "The VPC security groups assigned to the Lambda."
  default     = []
}

variable "datadog_log_subscription_arn" {
  type        = string
  description = "Log subscription arn for shipping logs to datadog"
  default     = ""
}

variable "lambda_role_policy" {
  type        = string
  description = "The Lambda IAM Role Policy."
  default     = <<END
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
END

}

variable "timeout" {
  type        = number
  description = "The maximum time in seconds that the Lambda can run for."
  default     = 3
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  default     = 128
}

variable "lambda_env" {
  description = "Environment parameters passed to the Lambda function."
  type        = map(string)
  default     = {}
}

variable "log_subscription_filter" {
  type        = string
  description = "Subscription filter to filter logs sent to datadog"
  default     = ""
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Reserved concurrent executions for this Lambda"
  default     = -1
}

variable "tags" {
  description = "A mapping of tags to assign to this lambda function."
  type        = map(string)
  default     = {}
}

variable "layers" {
  type        = list(string)
  description = "ARNs of the layers to attach to the lambda function in order"
  default     = []
}
