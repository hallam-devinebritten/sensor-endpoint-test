data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "lambda" {
  name               = "${var.name_prefix}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}


resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name_prefix}-api"
  retention_in_days = var.log_retention_days
}


data "aws_iam_policy_document" "lambda_logs" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }
}


resource "aws_iam_role_policy" "lambda_logs" {
  name   = "write-own-logs"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_logs.json
}


resource "aws_lambda_function" "api" {
  function_name    = "${var.name_prefix}-api"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.13"
  handler          = "handler.lambda_handler"
  architectures    = ["arm64"]
  filename         = var.package_path
  source_code_hash = filebase64sha256(var.package_path)
  memory_size      = var.memory_mb
  timeout          = var.timeout_seconds

  environment {
    variables = {
      APP_ENV     = var.environment
      APP_VERSION = var.app_version
      LOG_LEVEL   = var.log_level
    }
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda.name
  }
}