output "zone_name" {

  value = coalesce(
    try(azurerm_dns_zone.this[0].name, null),
    try(aws_route53_zone.this[0].name, null),
    try(google_dns_managed_zone.this[0].dns_name, null),
    try(oci_dns_zone.this[0].name, null),
    try(digitalocean_domain.this[0].name, null)
  )
}

output "zone_id" {

  value = coalesce(
    try(azurerm_dns_zone.this[0].id, null),
    try(aws_route53_zone.this[0].zone_id, null),
    try(google_dns_managed_zone.this[0].id, null),
    try(oci_dns_zone.this[0].id, null),
    try(digitalocean_domain.this[0].id, null)
  )
}

output "name_servers" {

  value = coalesce(
    try(azurerm_dns_zone.this[0].name_servers, null),
    try(aws_route53_zone.this[0].name_servers, null),
    try(google_dns_managed_zone.this[0].name_servers, null),
    try(oci_dns_zone.this[0].nameservers, null),
    null
  )
}