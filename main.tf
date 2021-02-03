terraform {
  required_version = ">= 0.12"
}

locals {
  default_lambda_sg = "${terraform.workspace}-default-lambda-sg"
  security_group_ids = var.security_group_ids != [] ? var.security_group_ids : [data.aws_security_group.default-lambda-sg.id]
}

data "aws_security_group" "default-lambda-sg" {
  name = local.default_lambda_sg
}


resource "aws_lambda_function" "lambda_function" {
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  function_name                  = var.function_name
  role                           = aws_iam_role.iam_for_lambda.arn
  handler                        = var.handler
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags                           = var.tags

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = local.security_group_ids
  }

  environment {
    variables = var.lambda_env
  }
}

resource "aws_cloudwatch_log_group" "lambda_loggroup" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
  depends_on        = [aws_lambda_function.lambda_function]
}

resource "aws_cloudwatch_log_subscription_filter" "kinesis_log_stream" {
  count           = var.datadog_log_subscription_arn != "" ? 1 : 0
  name            = "kinesis-log-stream-${var.function_name}"
  destination_arn = var.datadog_log_subscription_arn
  log_group_name  = aws_cloudwatch_log_group.lambda_loggroup.name
  filter_pattern  = var.log_subscription_filter
  depends_on      = [aws_lambda_function.lambda_function]
}
