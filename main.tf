resource "aws_lambda_function" "lambda_function" {
  image_uri                       = var.image_uri
  s3_bucket                       = var.s3_bucket
  s3_key                          = var.s3_key
  function_name                   = var.function_name
  role                            = aws_iam_role.iam_for_lambda.arn
  handler                         = var.handler
  runtime                         = var.runtime
  timeout                         = var.timeout
  memory_size                     = var.memory_size
  reserved_concurrent_executions  = var.reserved_concurrent_executions
  tags                            = var.tags
  package_type                    = var.image_uri != null ? "Image" : "Zip"
  layers                          = var.layers
  architectures                   = var.architectures

  dynamic "image_config" {
    for_each = var.image_uri != null ? [1] : []
    content  {
        command = var.image_config_command
        entry_point = var.image_config_entry_point
        working_directory = var.image_config_working_directory
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
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
