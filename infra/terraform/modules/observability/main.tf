# azure
resource "azurerm_log_analytics_workspace" "logs" {

  count = var.cloud_provider == "azure" ? 1 : 0

  name                = "${var.project_name}-logs"

  location            = var.location

  resource_group_name = var.resource_group_name

  retention_in_days   = var.retention_days
}

resource "azurerm_application_insights" "apm" {

  count = var.cloud_provider == "azure" ? 1 : 0

  name                = "${var.project_name}-appinsights"

  location            = var.location

  resource_group_name = var.resource_group_name

  workspace_id =
    azurerm_log_analytics_workspace.logs[0].id

  application_type = "web"
}

resource "azurerm_monitor_action_group" "alerts" {

  count = var.cloud_provider == "azure" ? 1 : 0

  name                = "${var.project_name}-alerts"

  resource_group_name = var.resource_group_name

  short_name = "alerts"
}

# aws
resource "aws_cloudwatch_log_group" "logs" {

  count = var.cloud_provider == "aws" ? 1 : 0

  name = "/${var.project_name}/logs"

  retention_in_days = var.retention_days
}

resource "aws_cloudwatch_dashboard" "main" {

  count = var.cloud_provider == "aws" ? 1 : 0

  dashboard_name =
    "${var.project_name}-dashboard"
}

resource "aws_xray_sampling_rule" "default" {

  count = var.cloud_provider == "aws" ? 1 : 0

  rule_name      = "${var.project_name}-sampling"
  priority       = 1000
  fixed_rate     = 0.1
  reservoir_size = 1

  host = "*"
  http_method = "*"
  url_path = "*"
  service_name = "*"
  service_type = "*"
}

resource "aws_s3_bucket" "metrics" {

  count = (
    var.cloud_provider == "aws" &&
    var.helm_managed
  ) ? 1 : 0

  bucket = "${var.project_name}-metrics"
}

resource "aws_s3_bucket" "traces" {

  count = (
    var.cloud_provider == "aws" &&
    var.helm_managed
  ) ? 1 : 0

  bucket = "${var.project_name}-traces"
}

resource "aws_sns_topic" "alerts" {

  count = var.cloud_provider == "aws" ? 1 : 0

  name = "${var.project_name}-alerts"
}

# gcp
resource "google_monitoring_monitored_project" "obs" {

  count = var.cloud_provider == "gcp" ? 1 : 0

  metrics_scope =
    "locations/global/metricsScopes/${var.project_id}"

  name = var.project_id
}

resource "google_logging_project_bucket_config" "logs" {

  count = var.cloud_provider == "gcp" ? 1 : 0

  project        = var.project_id
  location       = "global"
  retention_days = var.retention_days

  bucket_id = "${var.project_name}-logs"
}

# oracle
resource "oci_logging_log_group" "logs" {

  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id

  display_name = "${var.project_name}-logs"
}

resource "oci_apm_apm_domain" "apm" {

  count = var.cloud_provider == "oci" ? 1 : 0

  compartment_id = var.compartment_id

  display_name = "${var.project_name}-apm"
}

# digital ocean
resource "digitalocean_spaces_bucket" "obs" {

  count = var.cloud_provider == "digitalocean" ? 1 : 0

  name   = "${var.project_name}-observability"
  region = var.location
}


