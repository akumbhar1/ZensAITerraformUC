output "certificate_id" {

  value = coalesce(
    try(azurerm_key_vault_certificate.tls[0].id, null),
    try(aws_acm_certificate.tls[0].arn, null),
    try(google_certificate_manager_certificate.tls[0].id, null),
    try(oci_certificates_management_certificate.tls[0].id, null)
  )
}

output "certificate_name" {
  value = var.certificate_name
}

output "domains" {

  value = concat(
    [var.domain_name],
    var.subject_alternative_names
  )
}

output "ingress_tls" {

  value = {
    certificate_id   = coalesce(
      try(aws_acm_certificate.tls[0].arn, null),
      try(azurerm_key_vault_certificate.tls[0].id, null),
      try(google_certificate_manager_certificate.tls[0].id, null),
      try(oci_certificates_management_certificate.tls[0].id, null)
    )

    domain_name = var.domain_name
  }
}

output "k8s_tls_secret" {

  value = {
    name = "${var.certificate_name}-tls"
  }
}