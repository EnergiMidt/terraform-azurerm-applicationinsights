locals {
  name     = var.override_name == null ? "${var.system_name}-${lower(var.environment)}-ai" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_application_insights" "insights" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name

  application_type                      = var.application_type
  daily_data_cap_in_gb                  = var.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = var.daily_data_cap_notifications_disabled
  retention_in_days                     = var.retention_in_days
  sampling_percentage                   = var.sampling_percentage
  disable_ip_masking                    = var.disable_ip_masking
  workspace_id                          = var.workspace_id != null ? var.workspace_id : null
  local_authentication_disabled         = var.local_authentication_disabled
  internet_ingestion_enabled            = var.internet_ingestion_enabled
  internet_query_enabled                = var.internet_query_enabled
  force_customer_storage_for_profiler   = var.force_customer_storage_for_profiler

  lifecycle {
    ignore_changes = [
      application_type
    ]
  }

  tags = var.tags
}
