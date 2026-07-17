provider "aws" {
  region = var.region
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "oci" {
  region = var.region
}

provider "digitalocean" {
}