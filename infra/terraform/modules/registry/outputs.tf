output "registry_name" {

  value = coalesce(

    try(module.azure_registry[0].registry_name, null),
    try(module.aws_registry[0].registry_name, null),
    try(module.gcp_registry[0].registry_name, null),
    try(module.oci_registry[0].registry_name, null),
    try(module.do_registry[0].registry_name, null)
  )
}

output "repository_name" {

  value = coalesce(

    try(module.azure_registry[0].repository_name, null),
    try(module.aws_registry[0].repository_name, null),
    try(module.gcp_registry[0].repository_name, null),
    try(module.oci_registry[0].repository_name, null),
    try(module.do_registry[0].repository_name, null)
  )
}

output "registry_url" {

  value = coalesce(

    try(module.azure_registry[0].registry_url, null),
    try(module.aws_registry[0].registry_url, null),
    try(module.gcp_registry[0].registry_url, null),
    try(module.oci_registry[0].registry_url, null),
    try(module.do_registry[0].registry_url, null)
  )
}

output "push_identity" {

  value = var.cicd_principal_id
}

output "pull_identity" {

  value = var.cluster_principal_id
}

