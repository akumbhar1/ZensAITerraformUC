output "secret_store_id" {
  value = coalesce(
    try(azurerm_key_vault.vault[0].id, null),
    try(oci_kms_vault.vault[0].id, null),
    null
  )
}

output "secret_store_name" {
  value = var.secret_store_name
}

output "secret_names" {
  value = var.secret_names
}

output "k8s_configmap" {
  value = {
    SECRET_PROVIDER = var.cloud_provider
    SECRET_STORE    = var.secret_store_name
  }
}

output "external_secret_references" {

  value = {
    app_credentials = "application-credentials"
    db_credentials  = "database-credentials"
    cache_credentials = "cache-credentials"
    storage_credentials = "storage-credentials"
    jwt_key = "jwt-signing-key"
    encryption_key = "encryption-key"
    sonarqube_token = "sonarqube-token"
  }
}