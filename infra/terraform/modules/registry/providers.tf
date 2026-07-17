provider "azurerm" {
  features {}
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "oci" {
  region = var.oci_region
}

provider "digitalocean" {
  token = var.do_token
}