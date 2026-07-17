variable "do_token" {
  sensitive = true
}

variable "environment" {}
variable "region" {}

variable "cluster_name" {}

variable "node_size" {}

variable "node_count" {}

variable "domain_name" {}

variable "namespace" {}

variable "postgres_size" {}

variable "redis_size" {}

variable "storage_retention_days" {}

variable "allowed_cidrs" {
  type = list(string)
}