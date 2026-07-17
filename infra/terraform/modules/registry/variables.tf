variable "cloud_provider" {
  type = string
}

variable "registry_name" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "repository_prefix" {
  type    = string
  default = ""
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "enable_retention_policy" {
  type    = bool
  default = true
}

variable "cluster_principal_id" {
  description = "AKS/EKS/GKE/OKE/DOKS identity"
  type        = string
}

variable "cicd_principal_id" {
  description = "Azure DevOps/GitHub Actions/OIDC identity"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}