output "cache_id" {
  value = coalesce(
    try(azurerm_redis_cache.redis[0].id, null),
    try(aws_elasticache_cluster.redis[0].id, null),
    try(google_redis_instance.redis[0].id, null),
    try(oci_redis_redis_cluster.redis[0].id, null),
    try(digitalocean_database_cluster.redis[0].id, null)
  )
}

output "cache_name" {
  value = var.cache_name
}

output "cache_endpoint" {
  value = coalesce(
    try(azurerm_redis_cache.redis[0].hostname, null),
    try(aws_elasticache_cluster.redis[0].cache_nodes[0].address, null),
    try(google_redis_instance.redis[0].host, null),
    try(oci_redis_redis_cluster.redis[0].primary_endpoint, null),
    try(digitalocean_database_cluster.redis[0].host, null)
  )
}

output "cache_port" {
  value = coalesce(
    try(azurerm_redis_cache.redis[0].ssl_port, null),
    try(aws_elasticache_cluster.redis[0].port, null),
    try(google_redis_instance.redis[0].port, null),
    try(oci_redis_redis_cluster.redis[0].port, null),
    try(digitalocean_database_cluster.redis[0].port, null)
  )
}