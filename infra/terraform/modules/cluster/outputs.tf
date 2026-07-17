output "cluster_name" {
  value = var.cluster_name
}

output "provider" {
  value = var.cloud_provider
}

output "cluster_id" {
  value = try(
    azurerm_kubernetes_cluster.aks[0].id,
    aws_eks_cluster.eks[0].id,
    google_container_cluster.gke[0].id,
    oci_containerengine_cluster.oke[0].id,
    digitalocean_kubernetes_cluster.doks[0].id
  )
}

output "cluster_endpoint" {
  value = try(
    azurerm_kubernetes_cluster.aks[0].kube_config[0].host,
    aws_eks_cluster.eks[0].endpoint,
    google_container_cluster.gke[0].endpoint,
    oci_containerengine_cluster.oke[0].endpoints[0].private_endpoint,
    digitalocean_kubernetes_cluster.doks[0].endpoint
  )
}

output "cluster_version" {
  value = var.kubernetes_version
}
