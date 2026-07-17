# Azure
resource "azurerm_container_registry" "acr" {

  name                = var.registry_name
  location            = var.location
  resource_group_name = var.resource_group

  sku           = "Premium"
  admin_enabled = false

  tags = var.tags
}

resource "azurerm_role_assignment" "aks_pull" {

  scope                = azurerm_container_registry.acr.id

  role_definition_name = "AcrPull"

  principal_id = var.cluster_principal_id
}

resource "azurerm_role_assignment" "pipeline_push" {

  scope                = azurerm_container_registry.acr.id

  role_definition_name = "AcrPush"

  principal_id = var.cicd_principal_id
}

retention_policy {

  enabled = true

  days = var.retention_days
}

# AWS 
resource "aws_ecr_repository" "repo" {

  name = var.repository_name

  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "retention" {

  repository = aws_ecr_repository.repo.name

  policy = jsonencode({

    rules = [

      {
        rulePriority = 1

        description = "Expire images"

        selection = {
          tagStatus   = "any"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.retention_days
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "repository_policy" {

  repository = aws_ecr_repository.repo.name

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          AWS = var.cluster_principal_id
        }

        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
}

# GCP 
resource "google_artifact_registry_repository" "repo" {

  location      = var.region

  repository_id = var.repository_name

  format = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "gke_pull" {

  repository = google_artifact_registry_repository.repo.id

  role = "roles/artifactregistry.reader"

  member = "serviceAccount:${var.cluster_principal_id}"
}

# ORACLE 
resource "oci_artifacts_container_repository" "repo" {

  compartment_id = var.compartment_id

  display_name = var.repository_name

  is_immutable = true
}

resource "oci_identity_policy" "cluster_pull" {

  compartment_id = var.compartment_id

  statements = [
    "Allow dynamic-group OKENodes to read repos in compartment ${var.compartment_name}"
  ]
}


