# aws
data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.admin_secret_name
}

resource "aws_db_instance" "postgres" {

  count = var.database_type == "postgresql" ? 1 : 0

  identifier = var.name

  engine = "postgres"

  instance_class = var.sku

  allocated_storage = var.storage_gb

  username = var.admin_username

  password = jsondecode(
    data.aws_secretsmanager_secret_version.db.secret_string
  )["password"]

  backup_retention_period = var.backup_retention_days

  publicly_accessible = var.public_access
}

# azure
data "azurerm_key_vault_secret" "db" {
  name         = var.admin_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_postgresql_flexible_server" "postgres" {

  count = var.database_type == "postgresql" ? 1 : 0

  name = var.name

  sku_name = var.sku

  storage_mb = var.storage_gb * 1024

  administrator_login = var.admin_username

  administrator_password = data.azurerm_key_vault_secret.db.value

  backup_retention_days = var.backup_retention_days

  public_network_access_enabled = var.public_access
}

# gcp
resource "google_sql_database_instance" "postgres" {

  count = var.database_type == "postgresql" ? 1 : 0

  name             = var.name
  database_version = "POSTGRES_15"

  settings {

    tier = var.sku

    disk_size = var.storage_gb

    backup_configuration {
      enabled = true
    }
  }
}

# oracle
resource "oci_database_autonomous_database" "postgres" {

  display_name = var.name

  cpu_core_count = 2

  data_storage_size_in_gb = var.storage_gb

  db_name = var.name
}

# digital ocean 
resource "digitalocean_database_cluster" "postgres" {

  name       = var.name
  engine     = "pg"
  version    = "15"
  size       = var.sku
  region     = "nyc1"
  node_count = 1
}

# port mapping
locals {

  database_ports = {
    mysql      = 3306
    postgresql = 5432
    mongodb    = 27017
  }
}