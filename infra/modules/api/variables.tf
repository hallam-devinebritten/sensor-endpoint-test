variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "environment" {
  description = "Environment name passed to the app as APP_ENV"
  type        = string
}

variable "package_path" {
  description = "Path to the zip file containing the Lambda code"
  type        = string
}

variable "app_version" {
  description = "Version label passed to the app"
  type        = string
  default     = "dev"
}

variable "log_level" {
  description = "Python log level"
  type        = string
  default     = "INFO"
}

variable "memory_mb" {
  description = "Memory for the Lambda function (MB)"
  type        = number
  default     = 128
}

variable "timeout_seconds" {
  description = "Maximum run time per request (seconds)"
  type        = number
  default     = 5
}

variable "log_retention_days" {
  description = "How long are logs kept in CloudWatch"
  type        = number
  default     = 7
}