locals {
  environment = "dev"

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

module "network" {

  source = "../../modules/network"

  cloud_provider = "digitalocean"

  environment = local.environment

  region = var.region

  vpc_cidr = "10.10.0.0/16"

  allowed_cidrs = var.allowed_cidrs

  tags = local.tags
}

module "kubernetes" {

  source = "../../modules/kubernetes"

  cloud_provider = "digitalocean"

  environment = local.environment

  cluster_name = "doks-dev"

  region = var.region

  node_size = var.node_size

  node_count = var.node_count

  vpc_id = module.network.vpc_id

  tags = local.tags
}

module "registry" {

  source = "../../modules/registry"

  cloud_provider = "digitalocean"

  environment = local.environment

  registry_name = "dev-registry"
}

module "database" {

  source = "../../modules/database"

  cloud_provider = "digitalocean"

  environment = local.environment

  engine = "postgres"

  db_size = var.postgres_size

  vpc_id = module.network.vpc_id

  private_access = true

  tags = local.tags
}

module "cache" {

  source = "../../modules/cache"

  cloud_provider = "digitalocean"

  environment = local.environment

  engine = "redis"

  cache_size = var.redis_size

  vpc_id = module.network.vpc_id

  tags = local.tags
}

module "storage" {

  source = "../../modules/storage"

  cloud_provider = "digitalocean"

  environment = local.environment

  bucket_name = "platform-dev-storage"

  retention_days = 30

  tags = local.tags
}

module "dns" {

  source = "../../modules/dns"

  cloud_provider = "digitalocean"

  environment = local.environment

  domain_name = var.domain_name
}

module "tls" {

  source = "../../modules/tls"

  cloud_provider = "digitalocean"

  environment = local.environment

  domain_name = module.dns.domain_name
}

module "ingress" {

  source = "../../modules/ingress"

  cloud_provider = "digitalocean"

  environment = local.environment

  cluster_endpoint = module.kubernetes.endpoint

  namespace = var.namespace

  domain_name = module.dns.domain_name

  certificate_id = module.tls.certificate_id
}

module "observability" {

  source = "../../modules/observability"

  cloud_provider = "digitalocean"

  environment = local.environment

  cluster_name = module.kubernetes.cluster_name

  enable_grafana = true

  enable_prometheus = true

  enable_loki = true
}

module "secrets" {

  source = "../../modules/secrets"

  cloud_provider = "digitalocean"

  environment = local.environment

  cluster_name = module.kubernetes.cluster_name

  secret_store_name = "external-secrets"
}

