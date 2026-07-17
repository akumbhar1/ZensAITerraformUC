output "metrics_backend" {

  value = coalesce(
    try(azurerm_application_insights.apm[0].connection_string, null),
    try(google_monitoring_monitored_project.obs[0].name, null),
    null
  )
}

output "log_backend" {

  value = coalesce(
    try(azurerm_log_analytics_workspace.logs[0].id, null),
    try(aws_cloudwatch_log_group.logs[0].arn, null),
    try(google_logging_project_bucket_config.logs[0].id, null),
    try(oci_logging_log_group.logs[0].id, null),
    try(digitalocean_spaces_bucket.obs[0].name, null)
  )
}

output "trace_backend" {

  value = coalesce(
    try(azurerm_application_insights.apm[0].id, null),
    try(aws_xray_sampling_rule.default[0].id, null),
    try(oci_apm_apm_domain.apm[0].id, null),
    null
  )
}

output "alert_target" {

  value = coalesce(
    try(aws_sns_topic.alerts[0].arn, null),
    try(azurerm_monitor_action_group.alerts[0].id, null),
    null
  )
}

output "helm_values" {

  value = {
    metrics_bucket = "${var.project_name}-metrics"
    logs_bucket    = "${var.project_name}-logs"
    traces_bucket  = "${var.project_name}-traces"

    retention_days = var.retention_days
  }
}

