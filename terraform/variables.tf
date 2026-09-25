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
