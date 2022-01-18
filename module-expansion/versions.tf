terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.28"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
