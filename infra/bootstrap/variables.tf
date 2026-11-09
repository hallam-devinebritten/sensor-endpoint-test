variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}


variable "project" {
  description = "Project name (Prefixes resource name)"
  type        = string
  default     = "sensor-endpoints"
}


variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}


variable "environments" {
  description = "Environments that get their own deploy role"
  type        = set(string)
  default     = ["dev", "prod"]
}