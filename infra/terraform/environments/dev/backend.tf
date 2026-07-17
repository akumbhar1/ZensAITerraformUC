terraform {

  required_version = ">= 1.7"

  required_providers {

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.68"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }

  backend "s3" {

    endpoint = "nyc3.digitaloceanspaces.com"

    bucket = "terraform-state"

    key = "dev/terraform.tfstate"

    region = "us-east-1"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    use_path_style              = true
  }
}