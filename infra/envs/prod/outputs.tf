output "function_name" {
  description = "Name of the Lambda function"
  value       = module.api.function_name
}

output "log_group_name" {
  description = "CloudWatch log group for the function"
  value       = module.api.log_group_name
}


output "api_url" {
  description = "Public base URL of the HTTP API"
  value       = module.api.api_url
}