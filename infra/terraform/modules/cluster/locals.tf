locals {
  is_azure        = var.cloud_provider == "azure"
  is_aws          = var.cloud_provider == "aws"
  is_gcp          = var.cloud_provider == "gcp"
  is_oracle       = var.cloud_provider == "oracle"
  is_digitalocean = var.cloud_provider == "digitalocean"
}