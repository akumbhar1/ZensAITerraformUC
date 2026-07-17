# Azure Redis
resource "azurerm_redis_cache" "redis" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                = var.cache_name
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity = var.capacity
  family   = "C"
  sku_name = "Basic"

  minimum_tls_version = "1.2"
}


# AWS ElastiCache
resource "aws_elasticache_cluster" "redis" {
  count = var.cloud_provider == "aws" ? 1 : 0

  cluster_id           = var.cache_name
  engine               = "redis"
  engine_version       = var.redis_version
  node_type            = var.node_type
  num_cache_nodes      = 1
  port                 = 6379
}


# GCP Memorystore
resource "google_redis_instance" "redis" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  name           = var.cache_name
  tier           = "BASIC"
  memory_size_gb = var.memory_size_gb

  region         = var.location
  redis_version  = "REDIS_7_0"
}


# DO Managed Redis
resource "digitalocean_database_cluster" "redis" {
  count = var.cloud_provider == "digitalocean" ? 1 : 0

  name       = var.cache_name
  engine     = "redis"
  version    = "7"
  region     = var.location
  size       = "db-s-1vcpu-1gb"
  node_count = 1
}


# OCI Redis
resource "oci_redis_redis_cluster" "redis" {
  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = var.cache_name
  node_count     = 1
  node_memory_in_gbs = var.memory_size_gb
}

