variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Project name, used to prefix resources"
  type        = string
  default     = "sensor-endpoints"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "log_level" {
  description = "Python log level for the app"
  type        = string
}

variable "memory_mb" {
  description = "Memory for the Lambda function (MB)"
  type        = number
}

variable "log_retention_days" {
  description = "How long to keep logs in CloudWatch (days)"
  type        = number
}

variable "app_version" {
  description = "Version label passed to the app, normally the git commit SHA"
  type        = string
  default     = "local"
}

variable "package_path" {
  description = "Path to .zip containing the Lambda code"
  type        = string
  default     = "../../../dist/lambda.zip"
}