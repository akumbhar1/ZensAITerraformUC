# Azure → Azure DNS
resource "azurerm_dns_zone" "this" {

  count = lower(var.cloud_provider) == "azure" ? 1 : 0

  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

# AWS   → Route53
resource "aws_route53_zone" "this" {

  count = lower(var.cloud_provider) == "aws" ? 1 : 0

  name          = var.zone_name
  force_destroy = var.aws_force_destroy
}

# GCP   → Cloud DNS
resource "google_dns_managed_zone" "this" {

  count = lower(var.cloud_provider) == "gcp" ? 1 : 0

  name     = replace(var.zone_name, ".", "-")
  dns_name = "${var.zone_name}."
}

# DO    → DigitalOcean DNS
resource "digitalocean_domain" "this" {

  count = lower(var.cloud_provider) == "digitalocean" ? 1 : 0

  name = var.zone_name
}

# OCI   → OCI DNS
resource "oci_dns_zone" "this" {

  count = lower(var.cloud_provider) == "oci" ? 1 : 0

  compartment_id = var.oci_compartment_id
  name           = var.zone_name
  zone_type      = "PRIMARY"
}

