# AWS Lambda Terraform Module

[![Build Status](https://travis-ci.org/mergermarket/terraform-acuris-aws-lambda.svg?branch=master)](https://travis-ci.org/mergermarket/terraform-acuris-aws-lambda)

This module will deploy a Lambda function.

## Module Input Variables

- `function_name` - (string) - **REQUIRED** - The name of the Lambda function.
- `handler` - (map) - **REQUIRED** - The function within your code that Lambda calls to begin execution.
- `lambda_env` - (string) - Environment parameters passed to the Lambda function
- `lambda_role_policy` (string) - The Lambda IAM Role Policy.
- `log_subscription_filter` - (string) - Subscription filter to filter logs sent to datadog
- `memory_size` (number) - Amount of memory in MB your Lambda Function can use at runtime
- `runtime` - (string) - **REQUIRED** The runtime environment for the Lambda function you are uploading.
- `s3_bucket` - (string) - **REQUIRED** - The name of the bucket containing your uploaded Lambda deployment package.
- `s3_key` - (string) - **REQUIRED** - The s3 key for your Lambda deployment package.
- `security_group_ids` - (string) - **REQUIRED** The VPC security groups assigned to the Lambda.
- `subnet_ids` - (string) - **REQUIRED** The VPC subnets in which the Lambda runs.
- `timeout` (number) - The maximum time in seconds that the Lambda can run for
- `reserved_concurrent_executions` (number) - The amount of reserved concurrent executions for this lambda function.
- `tags` (map) - A mapping of tags to assign to this lambda function.


## Usage

```hcl
module "lambda" {
  source  = "mergermarket/aws-lambda/acuris"
  version = "0.0.1"
  s3_bucket                 = "s3_bucket_name"
  s3_key                    = "s3_key_for_lambda"
  function_name             = "do_foo"
  handler                   = "do_foo_handler"
  runtime                   = "nodejs"
  timeout                   = 5
  memory_size               = 256
  lambda_env                = "${var.lambda_env}"
}
```
Lambda environment variables file:
```json
{
  "lambda_env": {
    "environment_name": "ci-testing"
  }
}
```
