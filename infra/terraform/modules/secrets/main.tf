# azure
data "azurerm_client_config" "current" {
  count = var.cloud_provider == "azure" ? 1 : 0
}

resource "azurerm_key_vault" "vault" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                = var.secret_store_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = data.azurerm_client_config.current[0].tenant_id
  sku_name  = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  tags = var.tags
}

resource "azurerm_key_vault_secret" "placeholder" {
  for_each = var.cloud_provider == "azure"
    ? toset(var.secret_names)
    : []

  name         = each.value
  value        = "managed-via-approved-channel"
  key_vault_id = azurerm_key_vault.vault[0].id

  lifecycle {
    ignore_changes = [value]
  }
}

# aws
resource "aws_secretsmanager_secret" "secret" {
  for_each = var.cloud_provider == "aws"
    ? toset(var.secret_names)
    : []

  name = each.value

  recovery_window_in_days = 30

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "placeholder" {
  for_each = var.cloud_provider == "aws"
    ? toset(var.secret_names)
    : []

  secret_id = aws_secretsmanager_secret.secret[each.key].id

  secret_string = jsonencode({
    managed_by = "pipeline"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# gcp
resource "google_secret_manager_secret" "secret" {
  for_each = var.cloud_provider == "gcp"
    ? toset(var.secret_names)
    : []

  project   = var.project_id
  secret_id = each.value

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each = var.cloud_provider == "gcp"
    ? toset(var.secret_names)
    : []

  secret = google_secret_manager_secret.secret[each.key].id

  secret_data = "managed-via-pipeline"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

# oracle
resource "oci_kms_vault" "vault" {
  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id

  display_name = var.secret_store_name
  vault_type   = "DEFAULT"
}

resource "oci_kms_key" "master_key" {
  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = "master-key"

  management_endpoint = oci_kms_vault.vault[0].management_endpoint

  key_shape {
    algorithm = "AES"
    length    = 32
  }
}

resource "oci_vault_secret" "secret" {
  for_each = var.cloud_provider == "oci"
    ? toset(var.secret_names)
    : []

  compartment_id = var.compartment_id

  secret_name = each.value

  vault_id = oci_kms_vault.vault[0].id

  key_id = oci_kms_key.master_key[0].id
}

# digital ocean
resource "digitalocean_tag" "secret_group" {
  count = var.cloud_provider == "digitalocean" ? 1 : 0

  name = var.secret_store_name
}

