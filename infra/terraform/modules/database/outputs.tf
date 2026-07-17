locals {

  hostname = coalesce(
    try(module.azure_db[0].hostname, null),
    try(module.aws_db[0].hostname, null),
    try(module.gcp_db[0].hostname, null),
    try(module.oci_db[0].hostname, null),
    try(module.do_db[0].hostname, null)
  )
}

output "database_name" {
  value = var.name
}

output "database_type" {
  value = var.database_type
}

output "hostname" {
  value = local.hostname
}

output "port" {
  value = local.database_ports[var.database_type]
}

output "storage_gb" {
  value = var.storage_gb
}

output "secret_reference" {
  value = var.admin_secret_name
}

output "backup_retention_days" {
  value = var.backup_retention_days
}

output "public_access" {
  value = var.public_access
}
