module "api" {
  source = "../../modules/api"

  name_prefix        = "${var.project}-${var.environment}"
  environment        = var.environment
  package_path       = var.package_path
  app_version        = var.app_version
  log_level          = var.log_level
  memory_mb          = var.memory_mb
  log_retention_days = var.log_retention_days
}