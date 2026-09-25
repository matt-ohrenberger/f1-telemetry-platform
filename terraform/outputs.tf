output "database_name" {
  description = "MotherDuck database name"
  value       = motherduck_database.f1_analytics.name
}

output "database_id" {
  description = "MotherDuck database ID"
  value       = motherduck_database.f1_analytics.id
}

output "schemas" {
  description = "Created schemas for data pipeline"
  value = {
    raw     = motherduck_schema.raw.name
    staging = motherduck_schema.staging.name
    marts   = motherduck_schema.marts.name
  }
}

output "connection_string" {
  description = "MotherDuck connection string for dbt profiles.yml"
  value       = "motherduck://${var.motherduck_token}@${motherduck_database.f1_analytics.name}"
  sensitive   = true
}
