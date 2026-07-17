# azure
resource "azurerm_storage_account" "storage" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                     = lower(var.storage_name)
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = var.versioning_enabled

    delete_retention_policy {
      days = var.retention_days
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage[0].id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "folders" {
  for_each = var.cloud_provider == "azure"
    ? toset(var.folders)
    : []

  name                   = "${each.value}/"
  storage_account_name   = azurerm_storage_account.storage[0].name
  storage_container_name = azurerm_storage_container.container[0].name
  type                   = "Block"
}

# aws
resource "aws_s3_bucket" "storage" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = lower(var.storage_name)

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = aws_s3_bucket.storage[0].id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = aws_s3_bucket.storage[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.cloud_provider == "aws" ? 1 : 0
  bucket = aws_s3_bucket.storage[0].id

  rule {
    id     = "retention"
    status = "Enabled"

    expiration {
      days = var.retention_days
    }
  }
}

# gcp
resource "google_storage_bucket" "storage" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  name     = var.storage_name
  location = var.location
  project  = var.project_id

  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = var.retention_days
    }
  }

  encryption {
    default_kms_key_name = null
  }

  labels = var.tags
}

# oracle
resource "oci_objectstorage_bucket" "storage" {
  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.storage_name

  versioning = var.versioning_enabled ? "Enabled" : "Disabled"

  access_type = "NoPublicAccess"
}

data "oci_objectstorage_namespace" "ns" {
  count = var.cloud_provider == "oci" ? 1 : 0
}

resource "oci_objectstorage_retention_rule" "retention" {
  count = var.cloud_provider == "oci" ? 1 : 0

  bucket    = oci_objectstorage_bucket.storage[0].name
  namespace = data.oci_objectstorage_namespace.ns[0].namespace

  duration {
    time_amount = var.retention_days
    time_unit   = "DAYS"
  }
}

# digital ocean 
resource "digitalocean_spaces_bucket" "storage" {
  count  = var.cloud_provider == "digitalocean" ? 1 : 0

  name   = var.storage_name
  region = var.location

  versioning {
    enabled = var.versioning_enabled
  }
}

resource "digitalocean_spaces_bucket_policy" "private" {
  count  = var.cloud_provider == "digitalocean" ? 1 : 0
  bucket = digitalocean_spaces_bucket.storage[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Deny"
      Principal = "*"
      Action = "*"
      Resource = "*"
    }]
  })
}
