# AWS
# VPC
resource "aws_vpc" "this" {
  count = local.is_aws ? 1 : 0

  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = var.network_name
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = local.is_aws ? length(var.public_subnets) : 0

  vpc_id     = aws_vpc.this[0].id
  cidr_block = var.public_subnets[count.index]

  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private" {
  count = local.is_aws ? length(var.private_subnets) : 0

  vpc_id     = aws_vpc.this[0].id
  cidr_block = var.private_subnets[count.index]
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = local.is_aws ? 1 : 0
  vpc_id = aws_vpc.this[0].id
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = local.is_aws ? 1 : 0
}

resource "aws_nat_gateway" "this" {
  count = local.is_aws ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
}

# Security Group
resource "aws_security_group" "default" {
  count = local.is_aws ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Azure
# VNET
resource "azurerm_virtual_network" "this" {
  count = local.is_azure ? 1 : 0

  name                = var.network_name
  address_space       = [var.cidr_block]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Public Subnet
resource "azurerm_subnet" "public" {
  count = local.is_azure ? length(var.public_subnets) : 0

  name                 = "public-${count.index}"
  virtual_network_name = azurerm_virtual_network.this[0].name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.public_subnets[count.index]]
}

# Private Subnet
resource "azurerm_subnet" "private" {
  count = local.is_azure ? length(var.private_subnets) : 0

  name                 = "private-${count.index}"
  virtual_network_name = azurerm_virtual_network.this[0].name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.private_subnets[count.index]]
}

# NSG
resource "azurerm_network_security_group" "this" {
  count = local.is_azure ? 1 : 0

  name                = "${var.network_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Outbound Connectivity
resource "azurerm_nat_gateway" "this" {
  count = local.is_azure ? 1 : 0

  name                = "${var.network_name}-nat"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# GCP
resource "google_compute_network" "this" {
  count                   = local.is_gcp ? 1 : 0
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  count = local.is_gcp ? length(var.private_subnets) : 0

  name          = "private-${count.index}"
  ip_cidr_range = var.private_subnets[count.index]

  network = google_compute_network.this[0].id
  region  = var.region

  private_ip_google_access = true
}

resource "google_compute_router_nat" "this" {
  count = local.is_gcp ? 1 : 0

  name   = "${var.network_name}-nat"
  router = google_compute_router.router[0].name
  region = var.region
}

# OCI
resource "oci_core_vcn" "this" {
  count = local.is_oci ? 1 : 0

  cidr_blocks  = [var.cidr_block]
  display_name = var.network_name
}

resource "oci_core_subnet" "private" {
  count = local.is_oci ? length(var.private_subnets) : 0

  cidr_block = var.private_subnets[count.index]

  vcn_id = oci_core_vcn.this[0].id
}

resource "oci_core_nat_gateway" "this" {
  count = local.is_oci ? 1 : 0

  vcn_id = oci_core_vcn.this[0].id
}

# DigitalOcean
resource "digitalocean_vpc" "this" {
  count = local.is_do ? 1 : 0

  name     = var.network_name
  region   = var.region
  ip_range = var.cidr_block
}




