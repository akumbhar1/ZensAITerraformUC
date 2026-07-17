# Azure
resource "azurerm_kubernetes_cluster" "aks" {

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group

  kubernetes_version = var.kubernetes_version

  private_cluster_enabled = var.private_cluster_enabled

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {

    name       = "system"
    vm_size    = var.node_size

    node_count = var.node_count

    enable_auto_scaling = var.enable_autoscaling

    min_count = var.min_nodes
    max_count = var.max_nodes
  }
}

# AWS
resource "aws_eks_cluster" "eks" {

  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  version = var.kubernetes_version

  vpc_config {

    endpoint_private_access = var.private_cluster_enabled

    endpoint_public_access = !var.private_cluster_enabled

    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.eks.name

  scaling_config {

    desired_size = var.node_count

    min_size = var.min_nodes

    max_size = var.max_nodes
  }
}

# GCP
resource "google_container_cluster" "gke" {

  name     = var.cluster_name
  location = var.region

  min_master_version = var.kubernetes_version

  private_cluster_config {
    enable_private_nodes = var.private_cluster_enabled
  }
}

resource "google_container_node_pool" "default" {

  cluster = google_container_cluster.gke.name

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }
}


# DOC
resource "digitalocean_kubernetes_cluster" "doks" {

  name    = var.cluster_name
  region  = var.region
  version = var.kubernetes_version

  auto_upgrade = true

  node_pool {

    name       = "default"
    size       = var.node_size
    node_count = var.node_count

    auto_scale = true

    min_nodes = var.min_nodes
    max_nodes = var.max_nodes
  }
}


# ORACLE
resource "oci_containerengine_cluster" "oke" {

  name = var.cluster_name

  endpoint_config {
    is_public_ip_enabled = !var.private_cluster_enabled
  }
}

resource "oci_containerengine_node_pool" "oke_pool" {

  node_config_details {

    size = var.node_count
  }
}