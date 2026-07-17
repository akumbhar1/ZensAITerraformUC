variable "cloud_provider" {
  description = "Cloud provider to deploy cluster"
  type        = string

  validation {
    condition = contains(
      ["azure", "aws", "gcp", "oracle", "digitalocean"],
      lower(var.cloud_provider)
    )
    error_message = "Supported providers: azure, aws, gcp, oracle, digitalocean"
  }
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_count" {
  type    = number
  default = 3
}

# AWS

variable "aws_region" {
  type    = string
  default = null
}

# Azure

variable "resource_group_name" {
  type    = string
  default = null
}

variable "location" {
  type    = string
  default = null
}

# GCP

variable "project_id" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

# Oracle

variable "compartment_id" {
  type    = string
  default = null
}

variable "vcn_id" {
  type    = string
  default = null
}

# DigitalOcean

variable "do_region" {
  type    = string
  default = null
}