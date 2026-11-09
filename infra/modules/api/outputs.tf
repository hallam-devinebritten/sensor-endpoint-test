output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}


output "log_group_name" {
  description = "CloudWatch log group for the function"
  value       = aws_cloudwatch_log_group.lambda.name
}


output "api_url" {
  description = "Public base URL of the HTTP API"
  value       = aws_apigatewayv2_api.http.api_endpoint
}