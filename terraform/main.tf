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

# MotherDuck Analytics Database
resource "motherduck_database" "f1_analytics" {
  name = "${local.project_name}_${local.environment}"
}

# Raw Layer Schema - Source of truth from API ingestion
resource "motherduck_schema" "raw" {
  database = motherduck_database.f1_analytics.name
  name     = "raw"

  depends_on = [motherduck_database.f1_analytics]
}

# Staging Layer Schema - Cleaned and normalized data
resource "motherduck_schema" "staging" {
  database = motherduck_database.f1_analytics.name
  name     = "staging"

  depends_on = [motherduck_database.f1_analytics]
}

# Mart Layer Schema - Analytics-ready fact and dimension tables
resource "motherduck_schema" "marts" {
  database = motherduck_database.f1_analytics.name
  name     = "marts"

  depends_on = [motherduck_database.f1_analytics]
}

# Mart Layer Subschemas for organization (to be uncommented later)
# resource "motherduck_schema" "marts_facts" {
#   database = motherduck_database.f1_analytics.name
#   name     = "marts_facts"
#   depends_on = [motherduck_database.f1_analytics]
# }

# resource "motherduck_schema" "marts_dimensions" {
#   database = motherduck_database.f1_analytics.name
#   name     = "marts_dimensions"
#   depends_on = [motherduck_database.f1_analytics]
# }

# resource "motherduck_schema" "marts_aggregates" {
#   database = motherduck_database.f1_analytics.name
#   name     = "marts_aggregates"
#   depends_on = [motherduck_database.f1_analytics]
# }
