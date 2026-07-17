variable "cloud_provider" {
  description = "Cloud provider to use"
  type        = string

  validation {
    condition = contains(
      ["azure", "aws", "gcp", "oci", "digitalocean"],
      lower(var.cloud_provider)
    )
    error_message = "Supported providers are azure, aws, gcp, oci and digitalocean."
  }
}

variable "zone_name" {
  type        = string
  description = "DNS Zone Name"
}

variable "resource_group_name" {
  type        = string
  default     = null
}

variable "aws_force_destroy" {
  type    = bool
  default = false
}

variable "gcp_project" {
  type    = string
  default = null
}

variable "oci_compartment_id" {
  type    = string
  default = null
}