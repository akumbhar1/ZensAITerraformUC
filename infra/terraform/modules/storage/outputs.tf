output "storage_name" {
  value = var.storage_name
}

output "storage_url" {
  value = coalesce(
    try(azurerm_storage_account.storage[0].primary_blob_endpoint, null),
    try(aws_s3_bucket.storage[0].bucket_regional_domain_name, null),
    try(google_storage_bucket.storage[0].url, null),
    try(oci_objectstorage_bucket.storage[0].name, null),
    try(digitalocean_spaces_bucket.storage[0].urn, null)
  )
}

output "container_name" {
  value = var.container_name
}

output "k8s_configmap" {
  value = {
    STORAGE_PROVIDER = var.cloud_provider
    STORAGE_NAME     = var.storage_name
    CONTAINER_NAME   = var.container_name
    STORAGE_URL      = coalesce(
      try(azurerm_storage_account.storage[0].primary_blob_endpoint, null),
      try(aws_s3_bucket.storage[0].bucket_regional_domain_name, null),
      try(google_storage_bucket.storage[0].url, null),
      try(oci_objectstorage_bucket.storage[0].name, null),
      try(digitalocean_spaces_bucket.storage[0].urn, null)
    )
  }
}

output "k8s_secret" {
  sensitive = true

  value = {
    access_key = try(
      azurerm_storage_account.storage[0].primary_access_key,
      null
    )
  }
}