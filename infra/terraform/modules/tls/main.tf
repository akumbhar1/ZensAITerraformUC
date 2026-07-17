# azure
resource "azurerm_key_vault_certificate" "tls" {

  count = var.cloud_provider == "azure" ? 1 : 0

  name         = var.certificate_name
  key_vault_id = var.key_vault_id

  certificate_policy {

    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      subject = "CN=${var.domain_name}"

      validity_in_months = 12

      subject_alternative_names {
        dns_names = var.subject_alternative_names
      }
    }
  }
}

# aws
resource "aws_acm_certificate" "tls" {

  count = var.cloud_provider == "aws" ? 1 : 0

  domain_name = var.domain_name

  subject_alternative_names =
    var.subject_alternative_names

  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {

  for_each = var.cloud_provider == "aws"
    ? {
        for dvo in aws_acm_certificate.tls[0].domain_validation_options :
        dvo.domain_name => {
          name   = dvo.resource_record_name
          type   = dvo.resource_record_type
          record = dvo.resource_record_value
        }
      }
    : {}

  zone_id = var.hosted_zone_id

  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "tls" {

  count = var.cloud_provider == "aws" ? 1 : 0

  certificate_arn =
    aws_acm_certificate.tls[0].arn

  validation_record_fqdns =
    [for r in aws_route53_record.validation : r.fqdn]
}

# gcp
resource "google_certificate_manager_dns_authorization" "auth" {

  count = var.cloud_provider == "gcp" ? 1 : 0

  name   = "${var.certificate_name}-auth"
  domain = var.domain_name
}

resource "google_certificate_manager_certificate" "tls" {

  count = var.cloud_provider == "gcp" ? 1 : 0

  name = var.certificate_name

  managed {

    domains = concat(
      [var.domain_name],
      var.subject_alternative_names
    )

    dns_authorizations = [
      google_certificate_manager_dns_authorization.auth[0].id
    ]
  }
}

# oracle
resource "oci_certificates_management_certificate" "tls" {

  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id

  name = var.certificate_name

  certificate_config {

    config_type = "MANAGED_EXTERNALLY_ISSUED_BY_INTERNAL_CA"

    subject {
      common_name = var.domain_name
    }
  }
}

# digital ocean
locals {

  cert_manager_cluster_issuer = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "letsencrypt-prod"
    }

    spec = {
      acme = {
        email = "platform@example.com"

        server = "https://acme-v02.api.letsencrypt.org/directory"

        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }

        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}
