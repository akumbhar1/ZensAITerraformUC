Dev Environment
 ├── VPC
 ├── DOKS Kubernetes Cluster
 ├── Managed PostgreSQL
 ├── Managed Redis
 ├── Container Registry
 ├── Spaces Object Storage
 ├── DNS Zone
 ├── NGINX Ingress
 ├── Cert Manager + Let's Encrypt TLS
 ├── Observability Stack
 │    ├── Prometheus
 │    ├── Grafana
 │    └── Loki
 └── Secrets (DigitalOcean Kubernetes Secrets / External Secrets)

 environments/
└── dev/
    ├── backend.tf
    ├── providers.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── main.tf
    └── outputs.tf