terraform {
  required_version = ">= 1.17"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.23"
    }
  }

  backend "s3" {
    bucket = "sensor-endpoints-tfstate-650622040012"
    key = "bootstrap/terraform.tfstate"
    region = "eu-west-2"
    use_lockfile = true
    encrypt = true
  }
}