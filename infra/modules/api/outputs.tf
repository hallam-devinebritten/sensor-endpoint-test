output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}


output "log_group_name" {
  description = "CloudWatch log group for the function"
  value       = aws_cloudwatch_log_group.lambda.name
}