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

variable "storage_name" {
  description = "Storage account or bucket name"
  type        = string
}

variable "container_name" {
  description = "Blob container/bucket folder"
  type        = string
  default     = "application"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "encryption_enabled" {
  type    = bool
  default = true
}

variable "compartment_id" {
  default = null
}

variable "project_id" {
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "folders" {
  type = list(string)

  default = [
    "uploaded-files",
    "generated-artifacts",
    "transactions/input",
    "transactions/output",
    "logs"
  ]
}