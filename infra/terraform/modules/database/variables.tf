variable "cloud_provider" {
  description = "Target cloud provider"
  type        = string

  validation {
    condition = contains(
      ["azure", "aws", "gcp", "oci", "digitalocean"],
      lower(var.cloud_provider)
    )
    error_message = "Supported values: azure, aws, gcp, oci, digitalocean"
  }
}

variable "database_type" {
  description = "mysql, postgresql, mongodb"
  type        = string

  validation {
    condition = contains(
      ["mysql", "postgresql", "mongodb"],
      lower(var.database_type)
    )
    error_message = "Supported values: mysql, postgresql, mongodb"
  }
}

variable "name" {
  type = string
}

variable "sku" {
  description = "Database SKU or instance class"
  type        = string
}

variable "storage_gb" {
  description = "Database storage size"
  type        = number
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "restore_enabled" {
  type    = bool
  default = true
}

variable "public_access" {
  type    = bool
  default = false
}

variable "admin_username" {
  type      = string
  sensitive = true
}

variable "admin_secret_name" {
  description = "Secret Manager reference"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
