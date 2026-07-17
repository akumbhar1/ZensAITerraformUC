output "network_id" {
  value = try(
    aws_vpc.this[0].id,
    azurerm_virtual_network.this[0].id,
    google_compute_network.this[0].id,
    oci_core_vcn.this[0].id,
    digitalocean_vpc.this[0].id
  )
}

output "public_subnets" {
  value = try(
    aws_subnet.public[*].id,
    azurerm_subnet.public[*].id,
    google_compute_subnetwork.public[*].id,
    oci_core_subnet.public[*].id,
    []
  )
}

output "private_subnets" {
  value = try(
    aws_subnet.private[*].id,
    azurerm_subnet.private[*].id,
    google_compute_subnetwork.private[*].id,
    oci_core_subnet.private[*].id,
    []
  )
}

output "security_boundary_id" {
  value = try(
    aws_security_group.default[0].id,
    azurerm_network_security_group.this[0].id,
    null
  )
}