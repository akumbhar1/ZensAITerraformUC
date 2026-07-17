variable "cloud_provider" {
  type = string

  validation {
    condition = contains(
      ["azure", "aws", "gcp", "oci", "digitalocean"],
      lower(var.cloud_provider)
    )

    error_message = "Supported providers: azure, aws, gcp, oci, digitalocean"
  }
}

variable "secret_store_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "compartment_id" {
  type    = string
  default = null
}

variable "project_id" {
  type    = string
  default = null
}

variable "secret_names" {
  type = list(string)

  default = [
    "application-credentials",
    "database-credentials",
    "cache-credentials",
    "storage-credentials",
    "jwt-signing-key",
    "encryption-key",
    "sonarqube-token"
  ]
}

variable "tags" {
  type    = map(string)
  default = {}
}