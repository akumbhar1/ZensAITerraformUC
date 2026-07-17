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

variable "certificate_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)

  default = [
    "*.example.com"
  ]
}

variable "dns_zone_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "key_vault_id" {
  type    = string
  default = null
}

variable "hosted_zone_id" {
  type    = string
  default = null
}

variable "project_id" {
  type    = string
  default = null
}

variable "compartment_id" {
  type    = string
  default = null
}

variable "enable_cert_manager" {
  type    = bool
  default = false
}

