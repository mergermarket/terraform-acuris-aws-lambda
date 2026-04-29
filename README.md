# AWS Lambda Terraform Module

[![Test](https://github.com/mergermarket/terraform-acuris-aws-lambda/actions/workflows/test.yml/badge.svg)](https://github.com/mergermarket/terraform-acuris-aws-lambda/actions/workflows/test.yml)

This module will deploy a Lambda function. It supports both Zip and Image deployments.

> NOTE 1: if `image_uri` is set then ECR Image will be deployed regardless of what Zip deployment properties are set to.

> NOTE 2: if both `security_group_ids` and `subnet_ids` are empty then the Lambda will not have access to resources within a VPC.

## Module input variables (shared)

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `function_name` | string | **yes** | | The name of the Lambda function. |
| `lambda_env` | map(string) | no | `{}` | Environment parameters passed to the Lambda function. |
| `lambda_role_policy` | string | no | CloudWatch Logs policy | The Lambda IAM Role Policy. |
| `log_subscription_filter` | string | no | `""` | Subscription filter to filter logs sent to datadog. |
| `memory_size` | number | no | `128` | Amount of memory in MB your Lambda Function can use at runtime. |
| `security_group_ids` | list(string) | no | `null` | The VPC security groups assigned to the Lambda. |
| `subnet_ids` | list(string) | no | `[]` | The VPC subnets in which the Lambda runs. |
| `timeout` | number | no | `3` | The maximum time in seconds that the Lambda can run for. |
| `reserved_concurrent_executions` | number | no | `-1` | Reserved concurrent executions for this Lambda. |
| `tags` | map(string) | no | `{}` | A mapping of tags to assign to this lambda function. |
| `datadog_log_subscription_arn` | string | no | `""` | Log subscription ARN for shipping logs to Datadog. |
| `architectures` | list(string) | no | `["x86_64"]` | Lambda architectures to support. |
| `use_default_security_group` | bool | no | `false` | Use the default security group for the Lambda function. |
| `vpc_id` | string | no | `null` | The VPC ID in which the Lambda runs. |
| `tracing_mode` | string | no | `"PassThrough"` | Tracing mode for the Lambda. Valid options: `PassThrough` and `Active`. |
| `dead_letter_queue_arn` | string | no | `""` | The ARN of the dead letter queue for the Lambda function. |
| `disable_logging` | bool | no | `false` | Disable logging cloudwatch / otel.|

### Zip deployment variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `runtime` | string | **yes** | `null` | The runtime environment for the Lambda function you are uploading. |
| `handler` | string | **yes** | `null` | The function within your code that Lambda calls to begin execution. |
| `s3_bucket` | string | **yes** | `null` | The name of the bucket containing your uploaded Lambda deployment package. |
| `s3_key` | string | **yes** | `null` | The s3 key for your Lambda deployment package. |
| `layers` | list(string) | no | `[]` | ARNs of the layers to attach to the lambda function in order. |

### Image deployment variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `image_uri` | string | **yes** | `null` | URI to the image in ECR repo. |
| `image_config_command` | list(string) | no | `[]` | List of values with which to override CMD entry in the image. |
| `image_config_entry_point` | list(string) | no | `[]` | List of values with which to override ENTRYPOINT entry in the image. |
| `image_config_working_directory` | string | no | `null` | Value with which to override WORKDIR entry in the image. |

### Datadog metrics variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `datadog_metrics` | string | no | `"none"` | Add Datadog metrics extension (`"extension"`) and optional NodeJS handler wrapper (`"lambdajs"`). |
| `datadog_extension_layer_version` | number | no | `88` | Version number of the Datadog extension layer to add. |
| `datadog_lambdajs_layer_version` | number | no | `131` | Version number of the Datadog NodeJS lambda layer to add. |

When `datadog_metrics` is set to `"extension"`, the Datadog Extension layer is added and the `DD_SITE` / `DD_API_KEY_SECRET_ARN` environment variables are injected. When set to `"lambdajs"`, the Datadog NodeJS handler wrapper layer is also added and the handler is overridden to the Datadog wrapper (with `DD_LAMBDA_HANDLER` set to the original handler). Supported runtimes for `lambdajs`: `nodejs18.x`, `nodejs20.x`, `nodejs22.x`, `nodejs24.x`.

### OpenTelemetry Collector variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `enable_otel_collector` | bool | no | `false` | Whether to add the OpenTelemetry Collector Lambda layer and related environment variables. |
| `otel_collector_layer_extension_log_level` | string | no | `"error"` | Log level for the OpenTelemetry Collector Lambda layer extension. |
| `otel_datadog_log_subscription_arn_ssm_parameter_name` | string | no | `"otel-datadog-log-subscription-role-arn"` | The name of the SSM parameter containing the ARN of the Datadog log subscription role for the OpenTelemetry Collector. |

When `enable_otel_collector` is `true`:
- The `otel-collector-layer-<arch>` Lambda layer is attached.
- `OPENTELEMETRY_EXTENSION_LOG_LEVEL` and `AWS_ACCOUNT_ID` environment variables are injected.
- An IAM policy granting `sts:AssumeRole` on the role stored in the SSM parameter is attached.
- The CloudWatch log group and Datadog log subscription filter are **not** created by this module (the collector manages its own log routing).

## Outputs

| Name | Description |
|------|-------------|
| `lambda_arn` | The ARN of the Lambda function. |
| `lambda_function_name` | The function name of the Lambda. |
| `lambda_iam_role_name` | The name of the IAM role created for the Lambda. |
| `lambda_invoke_arn` | The invoke ARN of the Lambda function. |

## Usage

```hcl
module "lambda" {
  source        = "mergermarket/aws-lambda/acuris"
  version       = "1.0.1"
  function_name = "do_foo"
  handler       = "do_foo_handler"
  runtime       = "nodejs"
  s3_bucket     = "s3_bucket_name"
  s3_key        = "s3_key_for_lambda"
  timeout       = 5
  memory_size   = 256
  lambda_env    = var.lambda_env
  architectures = ["x86_64"]
  use_default_security_group = true
  vpc_id = module.platform_config.config["vpc"]
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
