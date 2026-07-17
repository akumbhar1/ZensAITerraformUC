output "cluster_name" {
  value = module.kubernetes.cluster_name
}

output "cluster_endpoint" {
  value = module.kubernetes.endpoint
}

output "registry_url" {
  value = module.registry.registry_url
}

output "namespace" {
  value = var.namespace
}

output "database_hostname" {
  value = module.database.hostname
}

output "cache_hostname" {
  value = module.cache.hostname
}

output "storage_bucket" {
  value = module.storage.bucket_name
}

output "ingress_endpoint" {
  value = module.ingress.endpoint
}

output "secret_manager_identifier" {
  value = module.secrets.secret_manager_identifier
}

output "database_connection_string" {
  value     = module.database.connection_string
  sensitive = true
}

output "cache_connection_string" {
  value     = module.cache.connection_string
  sensitive = true
}

output "kubeconfig" {
  value     = module.kubernetes.kubeconfig
  sensitive = true
}