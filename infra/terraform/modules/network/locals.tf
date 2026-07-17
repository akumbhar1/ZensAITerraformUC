locals {
  is_aws   = var.cloud_provider == "aws"
  is_azure = var.cloud_provider == "azure"
  is_gcp   = var.cloud_provider == "gcp"
  is_oci   = var.cloud_provider == "oci"
  is_do    = var.cloud_provider == "do"
}