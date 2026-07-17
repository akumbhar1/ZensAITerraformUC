variable "cloud_provider" {
  type = string

  validation {
    condition = contains(
      ["azure","aws","gcp","oci","digitalocean"],
      lower(var.cloud_provider)
    )

    error_message = "Supported providers: azure, aws, gcp, oci, digitalocean"
  }
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "location" {
  type = string
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "enable_metrics" {
  type    = bool
  default = true
}

variable "enable_logs" {
  type    = bool
  default = true
}

variable "enable_traces" {
  type    = bool
  default = true
}

variable "helm_managed" {
  type    = bool
  default = true
}