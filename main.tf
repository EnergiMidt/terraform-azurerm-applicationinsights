locals {
  name     = var.override_name == null ? "${var.system_short_name}-${var.app_name}-${lower(var.environment)}-appi" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location

  web_test = concat(azurerm_application_insights_web_test.web_test[*], [null])[0]
}

resource "azurerm_application_insights" "application_insights" {
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

resource "azurerm_application_insights_web_test" "web_test" {
  for_each = var.web_test_endpoints

  # This is a classic web test `azurerm_application_insights_web_test` resource.
  # https://github.com/hashicorp/terraform-provider-azurerm/pull/19954#issue-1527978917
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test
  #
  # Use `azurerm_application_insights_standard_web_test` resource for standard web test.
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test

  name                    = "${local.name}-${each.key}"
  location                = local.location
  resource_group_name     = var.resource_group.name
  application_insights_id = azurerm_application_insights.application_insights.id
  kind                    = try(each.value.ping, "ping")
  frequency               = try(each.value.frequency, 300)
  timeout                 = try(each.value.timeout, 30)
  enabled                 = try(each.value.enabled, true)
  retry_enabled           = try(each.value.retry_enabled, true)
  geo_locations           = try(each.value.geo_locations, []) # https://learn.microsoft.com/en-gb/azure/azure-monitor/app/monitor-web-app-availability#azure

  configuration = <<XML
<WebTest
  Name="${local.name}-${each.key}"
  Id="9a572603-75a7-4754-8f17-74d3a428d7fa"
  Enabled="${title(each.value.enabled)}"
  CssProjectStructure=""
  CssIteration=""
  Timeout="${each.value.timeout}"
  WorkItemIds=""
  xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
  Description=""
  CredentialUserName=""
  CredentialPassword=""
  PreAuthenticate="True"
  Proxy="default"
  StopOnError="False"
  RecordedResultFile=""
  ResultsLocale="">
  <Items>
    <Request
      Method="GET"
      Guid="a3e2335b-cee0-ecd3-c892-ca25c94275b4"
      Version="1.1"
      Url="${each.value.url}"
      ThinkTime="0"
      Timeout="${each.value.timeout}"
      ParseDependentRequests="False"
      FollowRedirects="True"
      RecordResult="True"
      Cache="False"
      ResponseTimeGoal="0"
      Encoding="utf-8"
      ExpectedHttpStatusCode="200"
      ExpectedResponseUrl=""
      ReportingName=""
      IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML

  tags = var.tags
}

resource "azurerm_monitor_action_group" "action_group" {
  for_each = var.monitor_action_group

  name                = each.value.name
  resource_group_name = var.resource_group.name
  short_name          = each.value.short_name

  dynamic "arm_role_receiver" {
    # for_each = toset(each.value.arm_role_receiver)
    for_each = each.value.arm_role_receiver

    content {
      name                    = arm_role_receiver.value.roles[arm_role_receiver.key].name
      role_id                 = split("/", arm_role_receiver.value.roles[arm_role_receiver.key].id)[4] # https://github.com/hashicorp/terraform-provider-azurerm/issues/8553
      use_common_alert_schema = true
    }
  }

  # dynamic "arm_role_receiver" {
  #   for_each = toset(each.value.arm_role_receiver)

  #   content {
  #     name                    = arm_role_receiver.value.name
  #     role_id                 = arm_role_receiver.value.role_id
  #     use_common_alert_schema = arm_role_receiver.value.use_common_alert_schema
  #   }
  # }

  dynamic "email_receiver" {
    for_each = toset(each.value.email_receiver)

    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = email_receiver.value.use_common_alert_schema
    }
  }

  tags = var.tags
}
