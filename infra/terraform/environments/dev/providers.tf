provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  host                   = module.kubernetes.endpoint
  token                  = module.kubernetes.token
  cluster_ca_certificate = base64decode(module.kubernetes.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes.endpoint
    token                  = module.kubernetes.token
    cluster_ca_certificate = base64decode(module.kubernetes.ca_certificate)
  }
}