terraform {
  required_version = ">= 1.5.0"
  required_providers {
    motherduck = {
      source  = "motherduckdb/motherduck"
      version = "~> 0.2.3"
    }
  }
}

provider "motherduck" {
  token = sensitive(var.motherduck_token)
}

locals {
  project_name = "f1-telemetry"
  environment  = var.environment
  tags = {
    project     = local.project_name
    environment = local.environment
    managed_by  = "terraform"
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "motherduck_token" {
  description = "MotherDuck API token (reads from MOTHERDUCK_TOKEN env var if not provided)"
  type        = string
  sensitive   = true
  default     = ""
}

resource "motherduck_database" "f1_analytics" {
  name                    = "${local.project_name}_${local.environment}"
}

output "database_name" {
  description = "MotherDuck database name"
  value       = motherduck_database.f1_analytics.name
}

output "database_id" {
  description = "MotherDuck database ID"
  value       = motherduck_database.f1_analytics.id
}