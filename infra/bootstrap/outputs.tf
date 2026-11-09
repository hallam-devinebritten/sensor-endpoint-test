output "state_bucket_name" {
  description = "The name of the S3 bucket used for storing Terraform state"
  value       = aws_s3_bucket.state.bucket
}

output "deploy_role_arns" {
  description = "IAM roles for GitHub Actions to assume, per enviroment"
  value       = { for env, role in aws_iam_role.deploy : env => role.arn }
}