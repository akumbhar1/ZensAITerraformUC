variable "cloud_provider" {
  description = "Cloud provider to deploy cache service"
  type        = string

  validation {
    condition = contains(
      ["azure", "aws", "gcp", "oci", "digitalocean"],
      lower(var.cloud_provider)
    )
    error_message = "Supported providers: azure, aws, gcp, oci, digitalocean"
  }
}

variable "cache_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "redis_version" {
  type    = string
  default = "7"
}

variable "capacity" {
  type    = number
  default = 1
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "memory_size_gb" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}